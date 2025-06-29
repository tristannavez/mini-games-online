extends Node

## GameManager - Manages game states and mini-game coordination
##
## This autoload singleton handles game flow, mini-game launching,
## and session management across all mini-games.

signal game_started(game_type: String)
signal game_ended(game_type: String, results: Dictionary)
signal all_players_ready()

enum GameState {
	MENU,
	LOBBY,
	IN_GAME,
	GAME_OVER
}

enum GameType {
	TIC_TAC_TOE
}

var current_state: GameState = GameState.MENU
var current_game_type: GameType
var game_results: Dictionary = {}
var min_players_per_game: Dictionary = {
	GameType.TIC_TAC_TOE: 2
}

func _ready() -> void:
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)

## Change the current game state
func set_game_state(new_state: GameState) -> void:
	current_state = new_state

## Start a mini-game if enough players are ready
func start_mini_game(game_type: GameType) -> bool:
	if not can_start_game(game_type):
		return false
	
	current_game_type = game_type
	set_game_state(GameState.IN_GAME)
	
	var game_scene_path = get_game_scene_path(game_type)
	get_tree().change_scene_to_file(game_scene_path)
	
	game_started.emit(GameType.keys()[game_type])
	return true

## Check if a game can be started
func can_start_game(game_type: GameType) -> bool:
	var required_players = min_players_per_game.get(game_type, 2)
	var connected_players = NetworkManager.get_player_count()
	var ready_players = count_ready_players()
	
	return connected_players >= required_players and ready_players >= required_players

## Count how many players are ready
func count_ready_players() -> int:
	var ready_count = 0
	var players = NetworkManager.get_all_players()
	
	for peer_id in players:
		var player_info = players[peer_id]
		var is_ready = player_info.get("ready", false)
		if is_ready:
			ready_count += 1
	
	return ready_count

## Get the scene path for a specific game type
func get_game_scene_path(game_type: GameType) -> String:
	match game_type:
		GameType.TIC_TAC_TOE:
			return "res://minigames/tictactoe/TicTacToe.tscn"
		_:
			return ""

## End the current game and return to lobby
func end_current_game(results: Dictionary = {}) -> void:
	game_results = results
	set_game_state(GameState.LOBBY)
	game_ended.emit(GameType.keys()[current_game_type], results)
	
	# Notify all players that someone is leaving the game
	player_leaving_game.rpc()
	
	# Reset all players' ready status when returning to lobby (only if server)
	if NetworkManager.is_server():
		reset_all_players_ready.rpc()
	
	# Return to lobby
	get_tree().change_scene_to_file("res://scenes/Lobby.tscn")

## Notify all players that someone is leaving the current game
@rpc("any_peer", "call_local", "reliable")
func player_leaving_game() -> void:
	# This will be handled by individual games if they need to react
	pass

## Reset all players ready status (called when returning from game)
@rpc("authority", "call_local", "reliable")
func reset_all_players_ready() -> void:
	var players = NetworkManager.get_all_players()
	for peer_id in players:
		if NetworkManager.players.has(peer_id):
			NetworkManager.players[peer_id]["ready"] = false
	
	# Sync the reset state
	if NetworkManager.is_server():
		NetworkManager.sync_all_players.rpc()

## Return to main menu
func return_to_menu() -> void:
	set_game_state(GameState.MENU)
	NetworkManager.disconnect_from_session()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

## Set local player ready status
func set_local_player_ready(is_ready: bool) -> void:
	var peer_id = multiplayer.get_unique_id()
	
	# Update local state immediately
	if NetworkManager.players.has(peer_id):
		NetworkManager.players[peer_id]["ready"] = is_ready
	
	# Sync with other players
	NetworkManager.set_player_ready.rpc(peer_id, is_ready)
	
	# Check if all players are ready
	if are_all_players_ready():
		all_players_ready.emit()

## Check if all connected players are ready
func are_all_players_ready() -> bool:
	var players = NetworkManager.get_all_players()
	if players.is_empty():
		return false
	
	for player_info in players.values():
		if not player_info.get("ready", false):
			return false
	
	return true

## Get game type name for display
func get_game_type_name(game_type: GameType) -> String:
	match game_type:
		GameType.TIC_TAC_TOE:
			return "Tic Tac Toe"
		_:
			return "Unknown Game"

## Network event handlers
func _on_player_connected(_peer_id: int, _player_info: Dictionary) -> void:
	pass  # Handle player connection if needed

func _on_player_disconnected(_peer_id: int) -> void:
	# Handle game state if player disconnects during game
	if current_state == GameState.IN_GAME:
		# Could pause game or end it depending on game type
		pass
