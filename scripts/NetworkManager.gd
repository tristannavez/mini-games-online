extends Node

## NetworkManager - Handles all multiplayer networking functionality
##
## This autoload singleton manages client/server connections, matchmaking,
## and network communication for all mini-games.

# Network event signals
signal player_connected(peer_id: int, player_info: Dictionary)
signal player_disconnected(peer_id: int)
signal server_disconnected()
signal connection_failed()
signal connection_succeeded()

const DEFAULT_PORT := 7000
const MAX_CLIENTS := 8

var multiplayer_peer: MultiplayerPeer
var players: Dictionary = {}
var local_player_info: Dictionary = {}

# Game session management
var current_game_session: Dictionary = {}
var public_games: Dictionary = {}  # Stores public games: {code: game_info}

# Matchmaking server configuration
var matchmaking_server_url: String = "http://localhost:8080"
var use_matchmaking_server: bool = false
var http_request: HTTPRequest

# Game session structure:
# {
#   "code": "1234",
#   "host_name": "PlayerName", 
#   "is_private": false,
#   "max_players": 4,
#   "current_players": 1,
#   "created_at": timestamp,
#   "host_id": peer_id
# }

func _ready() -> void:
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)
	
	# Setup HTTP request for matchmaking
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_http_request_completed)

## Create a server on the specified port
func create_server(port: int = DEFAULT_PORT) -> bool:
	multiplayer_peer = ENetMultiplayerPeer.new()
	var error = multiplayer_peer.create_server(port, MAX_CLIENTS)
	
	if error != OK:
		push_error("Failed to create server: " + str(error))
		return false
	
	multiplayer.multiplayer_peer = multiplayer_peer
	players[1] = local_player_info
	print("Server created on port ", port)
	return true

## Join a server at the specified address and port
func join_server(address: String, port: int = DEFAULT_PORT) -> bool:
	multiplayer_peer = ENetMultiplayerPeer.new()
	var error = multiplayer_peer.create_client(address, port)
	
	if error != OK:
		push_error("Failed to connect to server: " + str(error))
		return false
	
	multiplayer.multiplayer_peer = multiplayer_peer
	print("Attempting to connect to ", address, ":", port)
	return true

## Disconnect from current session
func disconnect_from_session() -> void:
	if multiplayer_peer:
		multiplayer_peer.close()
		multiplayer_peer = null
	
	multiplayer.multiplayer_peer = null
	players.clear()
	print("Disconnected from session")

## Set local player information
func set_local_player_info(player_name: String) -> void:
	local_player_info = {
		"name": player_name,
		"ready": false
	}

## Get player information by peer ID
func get_player_info(peer_id: int) -> Dictionary:
	return players.get(peer_id, {})

## Get all connected players
func get_all_players() -> Dictionary:
	return players

## Check if we are the server
func is_server() -> bool:
	return multiplayer.is_server()

## Get the number of connected players
func get_player_count() -> int:
	return players.size()

## Send player info to all peers (called when joining)
@rpc("any_peer", "reliable")
func register_player(player_info: Dictionary) -> void:
	var peer_id = multiplayer.get_remote_sender_id()
	players[peer_id] = player_info
	player_connected.emit(peer_id, player_info)

## Update player ready status
@rpc("any_peer", "call_local", "reliable")
func set_player_ready(peer_id: int, is_ready: bool) -> void:
	if players.has(peer_id):
		players[peer_id]["ready"] = is_ready
	
	# Emit signal to update UI
	player_connected.emit(peer_id, players.get(peer_id, {}))

## Sync all players state to all clients
@rpc("authority", "call_local", "reliable")
func sync_all_players() -> void:
	# This will be called on all clients to refresh their player list
	for peer_id in players:
		player_connected.emit(peer_id, players.get(peer_id, {}))

## Create a game session with metadata
func create_game_session(game_code: String, is_private: bool) -> void:
	current_game_session = {
		"code": game_code,
		"host_name": local_player_info.get("name", "Host"),
		"is_private": is_private,
		"max_players": MAX_CLIENTS,
		"current_players": 1,
		"created_at": Time.get_unix_time_from_system(),
		"host_id": 1,
		"server_ip": "127.0.0.1",  # In production, use public IP
		"server_port": DEFAULT_PORT
	}
	
	# If public, add to public games list
	if not is_private:
		public_games[game_code] = current_game_session.duplicate()
		print("Public game created: ", game_code)
		
		# Register on matchmaking server if enabled
		if use_matchmaking_server:
			register_game_on_server(current_game_session.duplicate())
	else:
		print("Private game created: ", game_code)

## Get list of public games
func get_public_games() -> Array:
	# If using matchmaking server, fetch fresh data
	if use_matchmaking_server:
		fetch_games_from_server()
	
	var games_list: Array = []
	var current_time = Time.get_unix_time_from_system()
	
	# Clean up old games (older than 30 minutes)
	for code in public_games.keys():
		var game = public_games[code]
		if current_time - game.get("created_at", 0) > 1800:  # 30 minutes
			public_games.erase(code)
		else:
			games_list.append(game)
	
	return games_list

## Join a public game by code
func join_public_game(game_code: String) -> bool:
	if game_code in public_games:
		var game = public_games[game_code]
		if game.get("current_players", 0) < game.get("max_players", MAX_CLIENTS):
			# Use server IP from game data, fallback to localhost
			var server_ip = game.get("server_ip", "127.0.0.1")
			var server_port = game.get("server_port", DEFAULT_PORT)
			return join_server(server_ip, server_port)
	return false

## Update current players count
@rpc("authority", "call_local")
func update_player_count(game_code: String, count: int) -> void:
	if game_code in public_games:
		public_games[game_code]["current_players"] = count
		if count <= 0:
			public_games.erase(game_code)  # Remove empty games
			# Unregister from matchmaking server if enabled
			if use_matchmaking_server:
				unregister_game_from_server(game_code)

## Update player info for already connected player
@rpc("any_peer", "call_local", "reliable")
func update_player_info(peer_id: int, updated_info: Dictionary) -> void:
	if players.has(peer_id):
		# Merge updated info with existing info
		for key in updated_info:
			players[peer_id][key] = updated_info[key]
		
		# Emit signal to update UI
		player_connected.emit(peer_id, players[peer_id])
	else:
		push_warning("Trying to update info for non-existent player " + str(peer_id))

## Network event handlers
func _on_player_connected(peer_id: int) -> void:
	# Send our player info to the new player
	register_player.rpc_id(peer_id, local_player_info)
	
	# Update public game player count if we're hosting
	if is_server() and not current_game_session.is_empty():
		var game_code = current_game_session.get("code", "")
		if game_code in public_games:
			update_player_count.rpc(game_code, players.size())

func _on_player_disconnected(peer_id: int) -> void:
	if players.has(peer_id):
		players.erase(peer_id)
		player_disconnected.emit(peer_id)
		
		# Update public game player count if we're hosting
		if is_server() and not current_game_session.is_empty():
			var game_code = current_game_session.get("code", "")
			if game_code in public_games:
				update_player_count.rpc(game_code, players.size())

func _on_connected_to_server() -> void:
	var peer_id = multiplayer.get_unique_id()
	players[peer_id] = local_player_info
	register_player.rpc(local_player_info)
	connection_succeeded.emit()

func _on_connection_failed() -> void:
	multiplayer_peer = null
	connection_failed.emit()

func _on_server_disconnected() -> void:
	print("Server disconnected")
	multiplayer_peer = null
	players.clear()
	server_disconnected.emit()

## Set matchmaking server URL and enable/disable it
func configure_matchmaking_server(server_url: String, enabled: bool = true) -> void:
	matchmaking_server_url = server_url
	use_matchmaking_server = enabled

## Register a public game on the matchmaking server
func register_game_on_server(game_data: Dictionary) -> void:
	if not use_matchmaking_server:
		return
	
	var json_data = JSON.stringify({
		"action": "register_game",
		"game_data": game_data
	})
	
	var headers = ["Content-Type: application/json"]
	http_request.request(matchmaking_server_url + "/api/games", headers, HTTPClient.METHOD_POST, json_data)

## Get list of public games from matchmaking server
func fetch_games_from_server() -> void:
	if not use_matchmaking_server:
		return
	
	http_request.request(matchmaking_server_url + "/api/games", [], HTTPClient.METHOD_GET)

## Remove a game from the matchmaking server
func unregister_game_from_server(game_code: String) -> void:
	if not use_matchmaking_server:
		return
	
	var json_data = JSON.stringify({
		"action": "unregister_game",
		"game_code": game_code
	})
	
	var headers = ["Content-Type: application/json"]
	http_request.request(matchmaking_server_url + "/api/games", headers, HTTPClient.METHOD_DELETE, json_data)

## Handle HTTP responses from matchmaking server
func _on_http_request_completed(_result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json_string = body.get_string_from_utf8()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		
		if parse_result == OK:
			var data = json.data
			match data.get("action", ""):
				"games_list":
					_handle_server_games_list(data.get("games", []))
				"game_registered":
					pass  # Game successfully registered
				"game_unregistered":
					pass  # Game successfully unregistered
	else:
		print("HTTP request failed with code: ", response_code)

## Handle games list received from server
func _handle_server_games_list(games_list: Array) -> void:
	# Clear old server games and add new ones
	for game in games_list:
		var code = game.get("code", "")
		if code:
			public_games[code] = game

## Get public game server IP from matchmaking server
func get_game_server_info(game_code: String) -> void:
	if not use_matchmaking_server:
		return
	
	http_request.request(matchmaking_server_url + "/api/games/" + game_code, [], HTTPClient.METHOD_GET)
