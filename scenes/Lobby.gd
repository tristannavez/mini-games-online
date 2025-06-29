extends Control

## Lobby - Multiplayer lobby for game selection and player management
##
## Allows players to ready up, select mini-games, and start matches
## when enough players are connected and ready.

@onready var players_list: VBoxContainer = $ResponsiveContainer/MainLayout/ContentLayout/LeftPanel/LeftMargin/LeftContainer/PlayersList
@onready var ready_btn: Button = $ResponsiveContainer/MainLayout/ContentLayout/LeftPanel/LeftMargin/LeftContainer/ReadyBtn
@onready var start_game_btn: Button = $ResponsiveContainer/MainLayout/ContentLayout/RightPanel/RightMargin/RightContainer/StartGameBtn
@onready var games_grid: GridContainer = $ResponsiveContainer/MainLayout/ContentLayout/RightPanel/RightMargin/RightContainer/GamesGrid

# UI elements for language system
@onready var title_label: Label = $ResponsiveContainer/MainLayout/HeaderContainer/TitleLabel
@onready var players_label: Label = $ResponsiveContainer/MainLayout/ContentLayout/LeftPanel/LeftMargin/LeftContainer/PlayersLabel
@onready var games_label: Label = $ResponsiveContainer/MainLayout/ContentLayout/RightPanel/RightMargin/RightContainer/GamesLabel
@onready var tic_tac_toe_btn: Button = $ResponsiveContainer/MainLayout/ContentLayout/RightPanel/RightMargin/RightContainer/GamesGrid/TicTacToeBtn
@onready var leave_btn: Button = $ResponsiveContainer/MainLayout/FooterContainer/LeaveBtn

var selected_game_type: GameManager.GameType = GameManager.GameType.TIC_TAC_TOE
var is_ready: bool = false

func _ready() -> void:
	# Connect network signals
	NetworkManager.player_connected.connect(_on_player_connected)
	NetworkManager.player_disconnected.connect(_on_player_disconnected)
	NetworkManager.server_disconnected.connect(_on_server_disconnected)
	
	# Connect game manager signals
	GameManager.all_players_ready.connect(_on_all_players_ready)
	
	# Connect language signals
	LanguageManager.language_changed.connect(_on_language_changed)
	
	# Setup modern UI animations
	UIManager.setup_modern_buttons_in_container(self)
	
	# Animate panels appearance
	var left_panel = $ResponsiveContainer/MainLayout/ContentLayout/LeftPanel
	var right_panel = $ResponsiveContainer/MainLayout/ContentLayout/RightPanel
	
	UIManager.animate_panel_show(left_panel)
	await get_tree().create_timer(0.1).timeout
	UIManager.animate_panel_show(right_panel)
	
	# Update UI language
	update_ui_language()

func update_ui_for_server_status() -> void:
	# Only server can start games
	if not NetworkManager.is_server():
		start_game_btn.visible = false

func refresh_players_list() -> void:
	# Clear existing player entries
	for child in players_list.get_children():
		child.queue_free()
	
	var players = NetworkManager.get_all_players()
	for peer_id in players:
		var player_info = players[peer_id]
		add_player_to_list(peer_id, player_info)

func add_player_to_list(peer_id: int, player_info: Dictionary) -> void:
	var player_container = HBoxContainer.new()
	player_container.add_theme_constant_override("separation", 8)
	
	# Simple color indicator for players
	var color_indicator = ColorRect.new()
	color_indicator.custom_minimum_size = Vector2(32, 32)
	var colors = [Color.BLUE, Color.RED, Color.GREEN, Color.YELLOW, Color.PURPLE, Color.ORANGE]
	color_indicator.color = colors[peer_id % colors.size()]
	player_container.add_child(color_indicator)
	
	var name_label = Label.new()
	name_label.text = player_info.get("name", "Unknown")
	name_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	
	var ready_indicator = Label.new()
	var is_player_ready = player_info.get("ready", false)
	ready_indicator.text = "✓" if is_player_ready else "○"
	ready_indicator.modulate = Color.GREEN if is_player_ready else Color.GRAY
	
	var role_label = Label.new()
	role_label.text = " (Host)" if peer_id == 1 else ""
	role_label.modulate = Color.YELLOW
	
	player_container.add_child(name_label)
	player_container.add_child(ready_indicator)
	player_container.add_child(role_label)
	
	players_list.add_child(player_container)

func _on_ready_btn_toggled(button_pressed: bool) -> void:
	is_ready = button_pressed
	ready_btn.text = LanguageManager.get_text("ready") if not is_ready else LanguageManager.get_text("not_ready")
	
	GameManager.set_local_player_ready(is_ready)
	
	# Delay refresh to allow network sync
	await get_tree().create_timer(0.1).timeout
	refresh_players_list()
	update_start_button()

func _on_leave_btn_pressed() -> void:
	GameManager.return_to_menu()

func _on_language_changed(_language_name: String) -> void:
	update_ui_language()

func update_ui_language() -> void:
	# Update all UI text elements with current language
	title_label.text = LanguageManager.get_text("game_lobby")
	players_label.text = LanguageManager.get_text("players")
	games_label.text = LanguageManager.get_text("mini_games")
	
	# Update ready button text based on state
	var ready_text = LanguageManager.get_text("ready") if not is_ready else LanguageManager.get_text("not_ready")
	ready_btn.text = ready_text
	
	# Update game buttons
	tic_tac_toe_btn.text = LanguageManager.get_text("tic_tac_toe")
	
	# Update action buttons
	start_game_btn.text = LanguageManager.get_text("start_game")
	leave_btn.text = LanguageManager.get_text("leave_lobby")

func _on_game_selected(game_type: int) -> void:
	selected_game_type = game_type as GameManager.GameType
	
	# Update button states
	for i in range(games_grid.get_child_count()):
		var btn = games_grid.get_child(i) as Button
		if btn:
			btn.disabled = (i == game_type)
	
	update_start_button()

func update_start_button() -> void:
	if not NetworkManager.is_server():
		return
	
	var can_start = GameManager.can_start_game(selected_game_type)
	var required_players = GameManager.min_players_per_game.get(selected_game_type, 2)
	var current_players = NetworkManager.get_player_count()
	var ready_players = GameManager.count_ready_players()
	
	start_game_btn.disabled = not can_start
	
	if can_start:
		start_game_btn.text = LanguageManager.get_text("start_game") + " " + GameManager.get_game_type_name(selected_game_type)
	else:
		start_game_btn.text = "Need " + str(required_players) + " ready players (" + str(ready_players) + "/" + str(current_players) + ")"

func _on_start_game_btn_pressed() -> void:
	if NetworkManager.is_server():
		start_selected_game.rpc()

@rpc("authority", "call_local", "reliable")
func start_selected_game() -> void:
	GameManager.start_mini_game(selected_game_type)

func _on_all_players_ready() -> void:
	update_start_button()

func _on_player_connected(_peer_id: int, player_info: Dictionary) -> void:
	UIManager.show_notification(player_info.get("name", "Player") + " joined the lobby!")
	refresh_players_list()
	update_start_button()

func _on_player_disconnected(_peer_id: int) -> void:
	UIManager.show_notification("A player left the lobby")
	refresh_players_list()
	update_start_button()

func _on_server_disconnected() -> void:
	UIManager.show_notification("Server disconnected!")
	await get_tree().create_timer(1.0).timeout
	GameManager.return_to_menu()
