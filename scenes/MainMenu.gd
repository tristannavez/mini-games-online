extends Control

## MainMenu - Entry point for the game
##
## Handles initial player setup, server creation/joining,
## and navigation to the game lobby.

@onready var name_input: LineEdit = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/PlayerNameContainer/NameInput
@onready var join_dialog: AcceptDialog = $JoinServerDialog
@onready var code_input: LineEdit = $JoinServerDialog/VBoxContainer/CodeContainer/CodeInput

# New dialogs for host game
var host_dialog: AcceptDialog
var host_type_option: OptionButton
var game_code_dialog: AcceptDialog
var game_code_label: Label
var copy_code_btn: Button

# New dialogs for join game selection
var join_type_dialog: AcceptDialog
var public_games_dialog: AcceptDialog
var public_games_list: ItemList
var refresh_btn: Button

# UI elements for language system
@onready var title_label: Label = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/TitleContainer/Title
@onready var subtitle_label: Label = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/TitleContainer/Subtitle
@onready var name_label: Label = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/PlayerNameContainer/NameLabel
@onready var host_game_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/ButtonsContainer/CreateServerBtn
@onready var join_game_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/ButtonsContainer/JoinServerBtn
@onready var language_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/SecondaryButtonsContainer/LanguageBtn
@onready var quick_match_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/SecondaryButtonsContainer/QuickMatchBtn
@onready var settings_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/SecondaryButtonsContainer/SettingsBtn
@onready var quit_btn: Button = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel/ContentMargin/VBoxContainer/SecondaryButtonsContainer/QuitBtn

var current_game_code: String = ""

func _ready() -> void:
	# Set default player name
	name_input.text = "Player" + str(randi_range(1000, 9999))
	
	# Configure matchmaking server (disable for production if not available)
	var use_matchmaking = OS.is_debug_build()
	if use_matchmaking:
		NetworkManager.configure_matchmaking_server("http://localhost:8080", true)
	else:
		NetworkManager.configure_matchmaking_server("", false)
	
	# Create host game dialogs
	create_host_dialogs()
	
	# Connect button signals manually to ensure they work (only if not already connected)
	if not host_game_btn.pressed.is_connected(_on_host_game_btn_pressed):
		host_game_btn.pressed.connect(_on_host_game_btn_pressed)
	if not join_game_btn.pressed.is_connected(_on_join_game_btn_pressed):
		join_game_btn.pressed.connect(_on_join_game_btn_pressed)
	if not quick_match_btn.pressed.is_connected(_on_quick_match_btn_pressed):
		quick_match_btn.pressed.connect(_on_quick_match_btn_pressed)
	if not language_btn.pressed.is_connected(_on_language_btn_pressed):
		language_btn.pressed.connect(_on_language_btn_pressed)
	if not settings_btn.pressed.is_connected(_on_settings_btn_pressed):
		settings_btn.pressed.connect(_on_settings_btn_pressed)
	if not quit_btn.pressed.is_connected(_on_quit_btn_pressed):
		quit_btn.pressed.connect(_on_quit_btn_pressed)
	if not join_dialog.confirmed.is_connected(_on_join_game_btn_pressed):
		join_dialog.confirmed.connect(_on_join_game_btn_pressed)
	
	# Connect network signals
	if not NetworkManager.connection_succeeded.is_connected(_on_connection_succeeded):
		NetworkManager.connection_succeeded.connect(_on_connection_succeeded)
	if not NetworkManager.connection_failed.is_connected(_on_connection_failed):
		NetworkManager.connection_failed.connect(_on_connection_failed)
	
	# Connect language signals
	if not LanguageManager.language_changed.is_connected(_on_language_changed):
		LanguageManager.language_changed.connect(_on_language_changed)
	
	# Set initial game state
	GameManager.set_game_state(GameManager.GameState.MENU)
	
	# Setup modern UI animations for all buttons
	UIManager.setup_modern_buttons_in_container(self)
	
	# Animate main panel appearance
	var content_panel = $ResponsiveContainer/MainLayout/CenterContainer/ContentPanel
	UIManager.animate_panel_show(content_panel)
	
	# Update UI texts with current language
	update_ui_language()

## Create host game dialogs dynamically
func create_host_dialogs() -> void:
	# Host setup dialog
	host_dialog = AcceptDialog.new()
	host_dialog.title = "Host Game"
	host_dialog.set_min_size(Vector2(400, 200))
	add_child(host_dialog)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	vbox.add_theme_constant_override("separation", 16)
	host_dialog.add_child(vbox)
	
	# Game type selection
	var type_label = Label.new()
	type_label.text = "Game Type"
	vbox.add_child(type_label)
	
	host_type_option = OptionButton.new()
	host_type_option.add_item("🔒 Private Game")
	host_type_option.add_item("🌐 Public Game")
	host_type_option.selected = 0  # Default to private
	vbox.add_child(host_type_option)
	
	# Game code display dialog
	game_code_dialog = AcceptDialog.new()
	game_code_dialog.title = "Game Created!"
	game_code_dialog.set_min_size(Vector2(350, 150))
	add_child(game_code_dialog)
	
	var code_vbox = VBoxContainer.new()
	code_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	code_vbox.add_theme_constant_override("separation", 12)
	game_code_dialog.add_child(code_vbox)
	
	var share_label = Label.new()
	share_label.text = "Share this code with your friends:"
	share_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	code_vbox.add_child(share_label)
	
	game_code_label = Label.new()
	game_code_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_code_label.add_theme_font_size_override("font_size", 24)
	code_vbox.add_child(game_code_label)
	
	copy_code_btn = Button.new()
	copy_code_btn.text = "📋 Copy Code"
	copy_code_btn.pressed.connect(_on_copy_code_pressed)
	code_vbox.add_child(copy_code_btn)
	
	# Create join dialogs
	create_join_dialogs()
	
	# Connect dialog signals
	host_dialog.confirmed.connect(_on_host_dialog_confirmed)
	game_code_dialog.confirmed.connect(_on_game_code_dialog_confirmed)

## Create join game dialogs
func create_join_dialogs() -> void:
	# Join type selection dialog
	join_type_dialog = AcceptDialog.new()
	join_type_dialog.title = "Join Game"
	join_type_dialog.set_min_size(Vector2(400, 200))
	add_child(join_type_dialog)
	
	var join_vbox = VBoxContainer.new()
	join_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	join_vbox.add_theme_constant_override("separation", 16)
	join_type_dialog.add_child(join_vbox)
	
	var join_label = Label.new()
	join_label.text = "How would you like to join?"
	join_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	join_vbox.add_child(join_label)
	
	var private_btn = Button.new()
	private_btn.text = "🔒 Enter Private Code"
	private_btn.pressed.connect(_on_private_code_btn_pressed)
	join_vbox.add_child(private_btn)
	
	var public_btn = Button.new()
	public_btn.text = "🌐 Browse Public Games"
	public_btn.pressed.connect(_on_public_games_btn_pressed)
	join_vbox.add_child(public_btn)
	
	# Public games browser dialog
	public_games_dialog = AcceptDialog.new()
	public_games_dialog.title = "Public Games"
	public_games_dialog.set_min_size(Vector2(500, 400))
	add_child(public_games_dialog)
	
	var public_vbox = VBoxContainer.new()
	public_vbox.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	public_vbox.add_theme_constant_override("separation", 12)
	public_games_dialog.add_child(public_vbox)
	
	var header_hbox = HBoxContainer.new()
	public_vbox.add_child(header_hbox)
	
	var games_label = Label.new()
	games_label.text = "Available Public Games:"
	header_hbox.add_child(games_label)
	
	refresh_btn = Button.new()
	refresh_btn.text = "🔄 Refresh"
	refresh_btn.pressed.connect(_on_refresh_games_pressed)
	header_hbox.add_child(refresh_btn)
	
	public_games_list = ItemList.new()
	public_games_list.custom_minimum_size = Vector2(450, 200)
	public_games_list.item_selected.connect(_on_public_game_selected)
	public_vbox.add_child(public_games_list)
	
	var join_selected_btn = Button.new()
	join_selected_btn.text = "🚀 Join Selected Game"
	join_selected_btn.pressed.connect(_on_join_selected_game_pressed)
	public_vbox.add_child(join_selected_btn)

func _on_host_game_btn_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name.is_empty():
		UIManager.show_notification(LanguageManager.get_text("error_name_required"))
		return
	
	# Set player info
	NetworkManager.set_local_player_info(player_name)
	# Show host setup dialog instead of creating server immediately
	update_host_dialog_language()
	host_dialog.popup_centered()

func _on_join_game_btn_pressed() -> void:
	var player_name = name_input.text.strip_edges()
	if player_name.is_empty():
		UIManager.show_notification(LanguageManager.get_text("error_name_required"))
		return
	
	# Set player info
	NetworkManager.set_local_player_info(player_name)
	# Show join type selection dialog
	join_type_dialog.popup_centered()

func _on_join_server_dialog_confirmed() -> void:
	var game_code = code_input.text.strip_edges()
	
	if game_code.is_empty() or game_code.length() != 4:
		UIManager.show_notification(LanguageManager.get_text("error_invalid_code"))
		return
	
	UIManager.show_loading_screen(LanguageManager.get_text("connecting"))
	# For now, just connect to localhost - in a real implementation,
	# you'd resolve the game code to an actual server address
	NetworkManager.join_server("127.0.0.1", 7000)

func _on_quick_match_btn_pressed() -> void:
	UIManager.show_notification("Quick Match feature coming soon!")
	# TODO: Implement matchmaking system

func _on_language_btn_pressed() -> void:
	LanguageManager.toggle_language()

func _on_language_changed(_language_name: String) -> void:
	update_ui_language()

func update_ui_language() -> void:
	# Update all UI text elements with current language
	title_label.text = LanguageManager.get_text("game_title")
	subtitle_label.text = LanguageManager.get_text("game_subtitle")
	name_label.text = LanguageManager.get_text("player_name")
	name_input.placeholder_text = LanguageManager.get_text("enter_name")
	
	host_game_btn.text = LanguageManager.get_text("host_game")
	join_game_btn.text = LanguageManager.get_text("join_game")
	language_btn.text = LanguageManager.get_text("language") + " " + LanguageManager.get_current_language_name()
	quick_match_btn.text = LanguageManager.get_text("quick_match")
	settings_btn.text = LanguageManager.get_text("settings")
	quit_btn.text = LanguageManager.get_text("quit")
	
	# Update dialog
	join_dialog.title = LanguageManager.get_text("join_game_title")
	$JoinServerDialog/VBoxContainer/CodeContainer/Label.text = LanguageManager.get_text("game_code")
	
	# Update host dialogs if they exist
	if host_dialog:
		update_host_dialog_language()
	if game_code_dialog:
		update_game_code_dialog_language()

func _on_quit_btn_pressed() -> void:
	get_tree().quit()

func _on_settings_btn_pressed() -> void:
	UIManager.show_notification("Settings menu coming soon!")

## Update host dialog text based on current language
func update_host_dialog_language() -> void:
	if host_dialog:
		host_dialog.title = LanguageManager.get_text("host_game_title")
		host_type_option.set_item_text(0, LanguageManager.get_text("private_game"))
		host_type_option.set_item_text(1, LanguageManager.get_text("public_game"))

## Handle host dialog confirmation
func _on_host_dialog_confirmed() -> void:
	var is_private = host_type_option.selected == 0  # 0 = private, 1 = public
	UIManager.show_loading_screen(LanguageManager.get_text("connecting"))
	
	if NetworkManager.create_server():
		# Generate a 4-digit game code
		current_game_code = str(randi_range(1000, 9999))
		
		# Create game session in NetworkManager
		NetworkManager.create_game_session(current_game_code, is_private)
		
		UIManager.hide_loading_screen()
		
		# Update and show the game code dialog
		update_game_code_dialog_language()
		game_code_label.text = current_game_code
		game_code_dialog.popup_centered()
	else:
		UIManager.hide_loading_screen()
		UIManager.show_notification(LanguageManager.get_text("error_server_start"))

## Update game code dialog text based on current language
func update_game_code_dialog_language() -> void:
	if game_code_dialog:
		game_code_dialog.title = LanguageManager.get_text("game_code_created")
		copy_code_btn.text = LanguageManager.get_text("copy_code")
		# Update the share text too
		var share_label = game_code_dialog.get_child(0).get_child(0) as Label
		if share_label:
			share_label.text = LanguageManager.get_text("share_code")

## Handle game code dialog confirmation (go to lobby)
func _on_game_code_dialog_confirmed() -> void:
	GameManager.set_game_state(GameManager.GameState.LOBBY)
	get_tree().change_scene_to_file("res://scenes/Lobby.tscn")

## Copy game code to clipboard
func _on_copy_code_pressed() -> void:
	DisplayServer.clipboard_set(current_game_code)
	UIManager.show_notification(LanguageManager.get_text_with_format("code_copied", [current_game_code]))

## Handle private code button pressed
func _on_private_code_btn_pressed() -> void:
	join_type_dialog.hide()
	join_dialog.popup_centered()

## Handle public games button pressed
func _on_public_games_btn_pressed() -> void:
	join_type_dialog.hide()
	refresh_public_games()
	public_games_dialog.popup_centered()

## Refresh the list of public games
func _on_refresh_games_pressed() -> void:
	refresh_public_games()

## Refresh public games list
func refresh_public_games() -> void:
	public_games_list.clear()
	var games = NetworkManager.get_public_games()
	
	if games.is_empty():
		public_games_list.add_item("No public games available")
		public_games_list.set_item_disabled(0, true)
	else:
		for game in games:
			var host_name = game.get("host_name", "Unknown")
			var current_players = game.get("current_players", 0)
			var max_players = game.get("max_players", 8)
			var code = game.get("code", "????")
			
			var item_text = "%s's Game (%d/%d) - Code: %s" % [host_name, current_players, max_players, code]
			public_games_list.add_item(item_text)
			public_games_list.set_item_metadata(public_games_list.get_item_count() - 1, game)

## Handle public game selection
func _on_public_game_selected(_index: int) -> void:
	# Just for UI feedback - the actual join happens on button press
	pass

## Join the selected public game
func _on_join_selected_game_pressed() -> void:
	var selected_items = public_games_list.get_selected_items()
	if selected_items.is_empty():
		UIManager.show_notification("Please select a game to join")
		return
	
	var selected_index = selected_items[0]
	var game_data = public_games_list.get_item_metadata(selected_index)
	
	if game_data and game_data is Dictionary:
		var game_code = game_data.get("code", "")
		if game_code:
			public_games_dialog.hide()
			UIManager.show_loading_screen(LanguageManager.get_text("connecting"))
			# Use the public game join function
			if NetworkManager.join_public_game(game_code):
				# Connection will be handled by the existing network signals
				pass
			else:
				UIManager.hide_loading_screen()
				UIManager.show_notification("Failed to join game - it may be full or no longer available")

## Network event handlers
func _on_connection_succeeded() -> void:
	UIManager.hide_loading_screen()
	GameManager.set_game_state(GameManager.GameState.LOBBY)
	get_tree().change_scene_to_file("res://scenes/Lobby.tscn")

func _on_connection_failed() -> void:
	UIManager.hide_loading_screen()
	UIManager.show_notification(LanguageManager.get_text("connection_failed"))


