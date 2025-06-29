extends Node

## Language Manager - Handles internationalization for the game
##
## Provides text translations and language switching functionality
## Supports French and English languages with easy extensibility

signal language_changed(new_language: String)

enum Language {
	FRENCH,
	ENGLISH
}

var current_language: Language = Language.ENGLISH
var translations: Dictionary = {}

func _ready() -> void:
	load_translations()
	# Load saved language preference
	var saved_language = load_language_preference()
	set_language(saved_language)

## Load all translations from data
func load_translations() -> void:
	translations = {
		Language.FRENCH: {
			# Main Menu
			"game_title": "MINI GAMES",
			"game_subtitle": "ONLINE",
			"player_name": "Nom du Joueur",
			"enter_name": "Entrez votre nom",
			"host_game": "🎮 Héberger une Partie",
			"join_game": "🔗 Rejoindre une Partie",
			"quick_match": "⚡ Match Rapide",
			"settings": "⚙️ Paramètres",
			"quit": "❌ Quitter",
			"language": "🌐 Langue",
			
			# Join Game Dialog
			"join_game_title": "Rejoindre une Partie",
			"game_code": "Code de la Partie",
			"enter_code": "Entrez le code",
			
			# Host Game Dialog
			"host_game_title": "Héberger une Partie",
			"game_type": "Type de Partie",
			"private_game": "🔒 Partie Privée",
			"public_game": "🌐 Partie Publique",
			"create_game": "Créer la Partie",
			"game_code_created": "Partie Créée !",
			"share_code": "Partagez ce code avec vos amis :",
			"copy_code": "📋 Copier le Code",
			"code_copied": "Code copié : {0}",
			
			# Join Game Options
			"join_type_title": "Rejoindre une Partie",
			"join_how": "Comment voulez-vous rejoindre ?",
			"enter_private_code": "🔒 Entrer un Code Privé",
			"browse_public_games": "🌐 Parcourir les Parties Publiques",
			"public_games_title": "Parties Publiques",
			"available_games": "Parties Publiques Disponibles :",
			"refresh_games": "🔄 Actualiser",
			"join_selected": "🚀 Rejoindre la Partie",
			"no_games": "Aucune partie publique disponible",
			"select_game": "Veuillez sélectionner une partie",
			"join_failed": "Échec de connexion - partie pleine ou indisponible",
			
			# Lobby
			"game_lobby": "🎮 Salon de Jeu",
			"players": "👥 Joueurs",
			"ready": "✅ Prêt",
			"not_ready": "⏳ Pas Prêt",
			"mini_games": "🎯 Mini-Jeux",
			"tic_tac_toe": "⭕ Morpion",
			"start_game": "🚀 Lancer Jeu",
			"leave_lobby": "🚪 Quitter Salon",
			"host": " (Hôte)",
			
			# TicTacToe
			"tic_tac_toe_title": "⭕ MORPION",
			"player_x_turn": "Tour du Joueur X",
			"player_o_turn": "Tour du Joueur O",
			"your_turn": "Votre tour",
			"opponent_turn": "Tour de l'adversaire",
			"you_win": "Vous gagnez !",
			"you_lose": "Vous perdez !",
			"draw": "Match nul !",
			"new_game": "🔄 Nouvelle Partie",
			"back_to_lobby": "🏠 Retour au Salon",
			"return_to_lobby": "🏠 Retour au Salon",

			
			# Network Messages
			"connecting": "Connexion...",
			"connected": "Connecté !",
			"connection_failed": "Connexion échouée",
			"server_started": "Serveur démarré",
			"player_joined": "Joueur rejoint",
			"player_left": "Un joueur a quitté la partie",
			"waiting_players": "En attente des joueurs...",
			"all_players_ready": "Tous les joueurs sont prêts !",
			"player_disconnected": "{0} s'est déconnecté",
			"server_disconnected": "Serveur déconnecté",
			"game_code_display": "Code de partie : {0}",
			
			# Errors
			"error_name_required": "Nom requis",
			"error_server_start": "Impossible de démarrer le serveur",
			"error_connection": "Erreur de connexion",
			"error_invalid_address": "Adresse invalide",
			"error_invalid_code": "Code de partie invalide",
			"back": "Retour",
		},
		
		Language.ENGLISH: {
			# Main Menu
			"game_title": "MINI GAMES",
			"game_subtitle": "ONLINE",
			"player_name": "Player Name",
			"enter_name": "Enter your name",
			"host_game": "🎮 Host Game",
			"join_game": "🔗 Join Game",
			"quick_match": "⚡ Quick Match",
			"settings": "⚙️ Settings",
			"quit": "❌ Quit",
			"language": "🌐 Language",
			
			# Join Game Dialog
			"join_game_title": "Join Game",
			"game_code": "Game Code",
			"enter_code": "Enter code",
			
			# Host Game Dialog
			"host_game_title": "Host Game",
			"game_type": "Game Type",
			"private_game": "🔒 Private Game",
			"public_game": "🌐 Public Game",
			"create_game": "Create Game",
			"game_code_created": "Game Created!",
			"share_code": "Share this code with your friends:",
			"copy_code": "📋 Copy Code",
			"code_copied": "Code copied: {0}",
			
			# Join Game Options
			"join_type_title": "Join Game",
			"join_how": "How would you like to join?",
			"enter_private_code": "🔒 Enter Private Code",
			"browse_public_games": "🌐 Browse Public Games",
			"public_games_title": "Public Games",
			"available_games": "Available Public Games:",
			"refresh_games": "🔄 Refresh",
			"join_selected": "🚀 Join Selected Game",
			"no_games": "No public games available",
			"select_game": "Please select a game",
			"join_failed": "Failed to join - game may be full or unavailable",
			
			# Lobby
			"game_lobby": "🎮 Game Lobby",
			"players": "👥 Players",
			"ready": "✅ Ready",
			"not_ready": "⏳ Not Ready",
			"mini_games": "🎯 Mini-Games",
			"tic_tac_toe": "⭕ Tic-Tac-Toe",
			"start_game": "🚀 Start Game",
			"leave_lobby": "🚪 Leave Lobby",
			"host": " (Host)",
			
			# TicTacToe
			"tic_tac_toe_title": "⭕ TIC TAC TOE",
			"player_x_turn": "Player X's Turn",
			"player_o_turn": "Player O's Turn",
			"your_turn": "Your turn",
			"opponent_turn": "Opponent's turn",
			"you_win": "You win!",
			"you_lose": "You lose!",
			"draw": "It's a draw!",
			"new_game": "🔄 New Game",
			"back_to_lobby": "🏠 Back to Lobby",
			"return_to_lobby": "🏠 Return to Lobby",

			
			# Network Messages
			"connecting": "Connecting...",
			"connected": "Connected!",
			"connection_failed": "Connection failed",
			"server_started": "Server started",
			"player_joined": "Player joined",
			"player_left": "Player left the game",
			"waiting_players": "Waiting for players...",
			"all_players_ready": "All players ready!",
			"player_disconnected": "{0} disconnected",
			"server_disconnected": "Server disconnected",
			"game_code_display": "Game Code: {0}",
			
			# Errors
			"error_name_required": "Name required",
			"error_server_start": "Failed to start server",
			"error_connection": "Connection error",
			"error_invalid_address": "Invalid address",
			"error_invalid_code": "Invalid game code",
			"back": "Back",
		}
	}

## Get translated text for a key
func get_text(key: String) -> String:
	var lang_dict = translations.get(current_language, {})
	return lang_dict.get(key, key)

## Get translated text with formatting
func get_text_with_format(key: String, values: Array) -> String:
	var text = get_text(key)
	for i in range(values.size()):
		text = text.replace("{" + str(i) + "}", str(values[i]))
	return text

## Set the current language
func set_language(language: Language) -> void:
	if language != current_language:
		current_language = language
		save_language_preference(language)
		language_changed.emit(get_language_name(language))

## Get language name for display
func get_language_name(language: Language) -> String:
	match language:
		Language.FRENCH:
			return "Français"
		Language.ENGLISH:
			return "English"
		_:
			return "Unknown"

## Get current language name
func get_current_language_name() -> String:
	return get_language_name(current_language)

## Toggle between languages
func toggle_language() -> void:
	match current_language:
		Language.FRENCH:
			set_language(Language.ENGLISH)
		Language.ENGLISH:
			set_language(Language.FRENCH)

## Save language preference to file
func save_language_preference(language: Language) -> void:
	var config = ConfigFile.new()
	config.set_value("settings", "language", language)
	config.save("user://settings.cfg")

## Load language preference from file
func load_language_preference() -> Language:
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		return config.get_value("settings", "language", Language.ENGLISH)
	return Language.ENGLISH

## Check if current language is French
func is_french() -> bool:
	return current_language == Language.FRENCH

## Check if current language is English
func is_english() -> bool:
	return current_language == Language.ENGLISH
