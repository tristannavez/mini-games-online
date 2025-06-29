extends Control

## TicTacToe - Multiplayer Tic-tac-toe mini-game
##
## A classic 3x3 grid game where players take turns placing X and O
## to get three in a row. Fully synchronized multiplayer implementation.

@onready var game_info_label: Label = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/TitleContainer/GameInfo
@onready var game_board: GridContainer = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/GameBoardContainer/GameBoard
@onready var restart_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/ActionsContainer/RestartBtn
@onready var quit_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/ActionsContainer/BackToLobbyBtn

# UI elements for language system
@onready var title_label: Label = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/TitleContainer/Title

enum CellState {
	EMPTY,
	X,
	O
}

var board_state: Array[CellState] = []
var current_player: CellState = CellState.X
var game_over: bool = false
var local_player_symbol: CellState
var player_names: Dictionary = {}

func _ready() -> void:
	initialize_game()
	setup_multiplayer()
	setup_player_names()
	
	# Connect network signals to handle disconnections
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	
	# Connect language signals
	LanguageManager.language_changed.connect(_on_language_changed)
	
	# Setup modern UI animations
	UIManager.setup_modern_buttons_in_container(self)
	
	# Animate game panel appearance
	var game_panel = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel
	UIManager.animate_panel_show(game_panel)
	
	# Update UI language
	update_ui_language()

func initialize_game() -> void:
	# Initialize board state
	board_state = []
	for i in range(9):
		board_state.append(CellState.EMPTY)
	
	current_player = CellState.X
	game_over = false
	
	# Setup board buttons
	setup_board_buttons()
	update_game_info()
	
	# Assign player symbols
	assign_player_symbols()

func setup_board_buttons() -> void:
	for i in range(9):
		var button = game_board.get_child(i) as Button
		if button:
			button.text = ""
			button.disabled = false
			if not button.pressed.is_connected(_on_cell_pressed):
				button.pressed.connect(_on_cell_pressed.bind(i))

func setup_multiplayer() -> void:
	# Get player names from NetworkManager
	var players = NetworkManager.get_all_players()
	for peer_id in players:
		player_names[peer_id] = players[peer_id].get("name", "Player " + str(peer_id))

func assign_player_symbols() -> void:
	var player_ids = NetworkManager.get_all_players().keys()
	player_ids.sort()
	
	# First player (usually server) gets X, second gets O
	if multiplayer.get_unique_id() == player_ids[0]:
		local_player_symbol = CellState.X
	else:
		local_player_symbol = CellState.O

func _on_cell_pressed(cell_index: int) -> void:
	if game_over or not is_local_player_turn():
		return
	
	if board_state[cell_index] != CellState.EMPTY:
		return
	
	# Make move locally and sync to other players
	make_move.rpc(cell_index, current_player)

@rpc("any_peer", "call_local", "reliable")
func make_move(cell_index: int, player: CellState) -> void:
	if game_over or board_state[cell_index] != CellState.EMPTY:
		return
	
	# Update board state
	board_state[cell_index] = player
	
	# Update button text
	var button = game_board.get_child(cell_index) as Button
	button.text = "X" if player == CellState.X else "O"
	button.disabled = true
	
	# Check for win or draw
	if check_winner():
		end_game(player)
	elif is_board_full():
		end_game(CellState.EMPTY) # Draw
	else:
		# Switch turns
		current_player = CellState.O if current_player == CellState.X else CellState.X
		update_game_info()

func check_winner() -> bool:
	# Check rows
	for row in range(3):
		var start = row * 3
		if board_state[start] != CellState.EMPTY and \
		   board_state[start] == board_state[start + 1] and \
		   board_state[start] == board_state[start + 2]:
			return true
	
	# Check columns
	for col in range(3):
		if board_state[col] != CellState.EMPTY and \
		   board_state[col] == board_state[col + 3] and \
		   board_state[col] == board_state[col + 6]:
			return true
	
	# Check diagonals
	if board_state[0] != CellState.EMPTY and \
	   board_state[0] == board_state[4] and \
	   board_state[0] == board_state[8]:
		return true
	
	if board_state[2] != CellState.EMPTY and \
	   board_state[2] == board_state[4] and \
	   board_state[2] == board_state[6]:
		return true
	
	return false

func is_board_full() -> bool:
	for cell in board_state:
		if cell == CellState.EMPTY:
			return false
	return true

func end_game(winner: CellState) -> void:
	game_over = true
	
	var message: String
	if winner == CellState.EMPTY:
		message = LanguageManager.get_text("draw")
	elif winner == local_player_symbol:
		message = LanguageManager.get_text("you_win")
	else:
		message = LanguageManager.get_text("you_lose")
	
	game_info_label.text = message
	
	# Disable all buttons
	for i in range(9):
		var button = game_board.get_child(i) as Button
		button.disabled = true
	
	# Enable restart button for server
	if NetworkManager.is_server():
		restart_btn.disabled = false

func update_game_info() -> void:
	if game_over:
		return
	
	if is_local_player_turn():
		var symbol = "X" if local_player_symbol == CellState.X else "O"
		game_info_label.text = LanguageManager.get_text("your_turn") + " (" + symbol + ")"
	else:
		var symbol = "X" if current_player == CellState.X else "O"
		game_info_label.text = LanguageManager.get_text("opponent_turn") + " (" + symbol + ")"
	
	# Update player display highlighting
	update_player_highlighting()

func is_local_player_turn() -> bool:
	return current_player == local_player_symbol

func _on_restart_btn_pressed() -> void:
	if NetworkManager.is_server():
		restart_game.rpc()

@rpc("authority", "call_local", "reliable")
func restart_game() -> void:
	initialize_game()

func _on_back_to_lobby_btn_pressed() -> void:
	# Notify other players that this player is leaving
	player_left_game.rpc()
	GameManager.end_current_game()

## Handle when a player leaves the game during play
@rpc("any_peer", "call_local", "reliable")
func player_left_game() -> void:
	if not game_over:
		game_over = true
		game_info_label.text = LanguageManager.get_text("player_left") if LanguageManager.get_text("player_left") != "player_left" else "Player left the game"
		
		# Disable all buttons
		for i in range(9):
			var button = game_board.get_child(i) as Button
			button.disabled = true
		
		# Enable back to lobby button for remaining player
		quit_btn.disabled = false
		restart_btn.disabled = true

## Handle player disconnection during game
func _on_player_disconnected(peer_id: int) -> void:
	if not game_over:
		var player_name = player_names.get(peer_id, "Unknown Player")
		game_over = true
		var disconnect_msg = LanguageManager.get_text("player_disconnected") if LanguageManager.get_text("player_disconnected") != "player_disconnected" else "{0} disconnected"
		game_info_label.text = disconnect_msg.replace("{0}", player_name)
		
		# Disable all buttons
		for i in range(9):
			var button = game_board.get_child(i) as Button
			button.disabled = true
		
		# Enable back to lobby button
		quit_btn.disabled = false
		restart_btn.disabled = true

## Handle server disconnection
func _on_server_disconnected() -> void:
	if not game_over:
		game_over = true
		game_info_label.text = LanguageManager.get_text("server_disconnected") if LanguageManager.get_text("server_disconnected") != "server_disconnected" else "Server disconnected"
		
		# Disable all buttons
		for i in range(9):
			var button = game_board.get_child(i) as Button
			button.disabled = true
		
		# Enable back to lobby button
		quit_btn.disabled = false
		restart_btn.disabled = true

func _on_language_changed(_language_name: String) -> void:
	update_ui_language()

func update_ui_language() -> void:
	# Update all UI text elements with current language
	title_label.text = LanguageManager.get_text("tic_tac_toe_title")
	restart_btn.text = LanguageManager.get_text("new_game")
	quit_btn.text = LanguageManager.get_text("back_to_lobby")
	
	# Update game info if game is not over
	if not game_over:
		update_game_info()

## Setup player name information
func setup_player_names() -> void:
	# Get player data from NetworkManager
	var players = NetworkManager.get_all_players()
	for peer_id in players:
		var player_data = players[peer_id]
		player_names[peer_id] = player_data.get("name", "Player " + str(peer_id))
	
	# Update UI to show player names
	update_player_display()

## Update the game info to show player names
func update_player_display() -> void:
	# Create or update player info display
	var title_container = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/TitleContainer
	
	# Remove existing player info if any
	for child in title_container.get_children():
		if child.name == "PlayersInfo":
			child.queue_free()
	
	# Create new player info container
	var players_info = HBoxContainer.new()
	players_info.name = "PlayersInfo"
	players_info.add_theme_constant_override("separation", 20)
	title_container.add_child(players_info)
	
	# Show both players with their info
	var player_ids = NetworkManager.get_all_players().keys()
	player_ids.sort()
	
	for i in range(min(2, player_ids.size())):
		var peer_id = player_ids[i]
		var player_name = player_names.get(peer_id, "Player " + str(peer_id))
		
		# Create player container
		var player_container = VBoxContainer.new()
		player_container.custom_minimum_size = Vector2(100, 80)
		players_info.add_child(player_container)
		
		# Simple color indicator for player
		var color_indicator = ColorRect.new()
		color_indicator.custom_minimum_size = Vector2(48, 48)
		var colors = [Color.BLUE, Color.RED, Color.GREEN, Color.YELLOW, Color.PURPLE, Color.ORANGE]
		color_indicator.color = colors[peer_id % colors.size()]
		player_container.add_child(color_indicator)
		
		# Player name and symbol
		var info_label = Label.new()
		var symbol = "X" if i == 0 else "O"
		info_label.text = player_name + " (" + symbol + ")"
		info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		info_label.add_theme_font_size_override("font_size", 12)
		player_container.add_child(info_label)
		
		# Highlight current player
		if (i == 0 and current_player == CellState.X) or (i == 1 and current_player == CellState.O):
			info_label.modulate = Color.YELLOW
		else:
			info_label.modulate = Color.WHITE

## Update player highlighting in the display
func update_player_highlighting() -> void:
	var title_container = $ResponsiveContainer/MainLayout/CenterContainer/GamePanel/MarginContainer/VBoxContainer/TitleContainer
	var players_info = title_container.get_node("PlayersInfo")
	
	if players_info:
		var player_ids = NetworkManager.get_all_players().keys()
		player_ids.sort()
		
		for i in range(min(2, players_info.get_child_count())):
			var player_container = players_info.get_child(i)
			var info_label = player_container.get_child(1) if player_container.get_child_count() > 1 else null
			
			if info_label and info_label is Label:
				# Highlight current player
				if (i == 0 and current_player == CellState.X) or (i == 1 and current_player == CellState.O):
					info_label.modulate = Color.YELLOW
				else:
					info_label.modulate = Color.WHITE
