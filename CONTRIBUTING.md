# Contributing to Mini Games Online

Thank you for your interest in contributing to Mini Games Online! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- **Godot 4.4.1+** - Download from [godotengine.org](https://godotengine.org/)
- **Git** - For version control
- **VS Code** (recommended) - With Godot Tools extension

### Development Setup

1. **Fork the repository**
   ```bash
   # Fork on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/mini_games_online.git
   cd mini_games_online
   ```

2. **Open in Godot**
   - Launch Godot 4.4.1+
   - Click "Import" and select `project.godot`
   - Let Godot import all assets

3. **Configure VS Code** (optional but recommended)
   ```bash
   code .
   # Install Godot Tools extension for better GDScript support
   ```

## 📏 Code Standards

### Language Usage
- **GDScript Comments:** Write in English
- **Documentation:** Write in English
- **UI Text:** Managed through LanguageManager (French/English)

### Naming Conventions
- **Variables/Functions:** `snake_case`
- **Classes/Scenes:** `PascalCase`
- **Constants:** `UPPER_SNAKE_CASE`
- **Signals:** `snake_case` with descriptive verbs

### Code Style
```gdscript
extends Node

## Class that manages basic functionality
## Description of main responsibilities

signal something_happened(data: Dictionary)

const MAX_PLAYERS := 4

var current_state: GameState = GameState.IDLE
var players: Dictionary = {}

func _ready() -> void:
	# Initialize components
	setup_connections()

## Function that does something important
func do_something(parameter: String) -> bool:
	if parameter.is_empty():
		return false
	
	# Business logic here
	return true
```

### Architecture Guidelines
- **Autoloads:** Use for global systems (NetworkManager, GameManager, etc.)
- **Signals:** Preferred over direct function calls for loose coupling
- **Type hints:** Always use when possible
- **Error handling:** Implement proper error checking for network operations

## 🎮 Adding New Mini-Games

### Structure
Create a new directory under `minigames/`:
```
minigames/
└── your_game/
    ├── YourGame.tscn    # Main game scene
    ├── YourGame.gd      # Game logic
    └── README.md        # Game-specific documentation
```

### Implementation Checklist
- [ ] **Networking:** Implement RPC methods for multiplayer sync
- [ ] **UI:** Follow the modern dark theme established
- [ ] **Mobile:** Ensure touch-friendly controls
- [ ] **Language:** Add text keys to LanguageManager
- [ ] **GameManager:** Add enum and scene path
- [ ] **Documentation:** Update README and create game guide

### Required Functions
Every mini-game must implement:
```gdscript
## Initialize the game for multiplayer
func setup_multiplayer() -> void

## Handle player connection
func _on_player_connected(peer_id: int, player_info: Dictionary) -> void

## Handle player disconnection
func _on_player_disconnected(peer_id: int) -> void

## End the game and return to lobby
func end_game(results: Dictionary = {}) -> void
```

## 🧪 Testing

### Multiplayer Testing
Always test with multiple instances:
```bash
# Use provided scripts
./tools/launch_multiplayer_test.ps1

# Or VS Code task: "Launch Multiple Instances for Testing"
```

### Mobile Testing
Test responsive design:
```bash
# Advanced mobile device simulator
./tools/mobile_device_simulator.ps1 -Device Android -DualDevice
```

### Test Checklist
- [ ] **Single player:** Game loads and displays correctly
- [ ] **Two players:** Basic multiplayer functionality
- [ ] **Four players:** Maximum capacity handling
- [ ] **Disconnection:** Graceful handling of player leaving
- [ ] **Mobile:** Touch controls work properly
- [ ] **Languages:** Both French and English display correctly

## 🌍 Internationalization

### Adding Text
Add new text keys to `LanguageManager.gd`:
```gdscript
translations = {
    Language.FRENCH: {
        "your_key": "Votre texte français",
    },
    Language.ENGLISH: {
        "your_key": "Your English text",
    }
}
```

### Usage in Code
```gdscript
# Get translated text
var text = LanguageManager.get_text("your_key")

# With formatting
var formatted = LanguageManager.get_text_with_format("player_score", [player_name, score])
```

## 📝 Documentation

### Code Documentation
- Write function documentation in English
- Include parameter descriptions and return values
- Document complex algorithms and networking logic

### User Documentation
- Write user-facing docs in English
- Include screenshots for UI features
- Provide step-by-step guides

## 🚀 Submission Process

### Preparing Your PR

1. **Create feature branch**
   ```bash
   git checkout -b feature/new-awesome-game
   ```

2. **Make your changes**
   - Follow code standards
   - Add/update documentation
   - Test thoroughly

3. **Commit with clear messages**
   ```bash
   git add .
   git commit -m "feat: add awesome new mini-game

   - Implement core game mechanics
   - Add multiplayer synchronization
   - Include mobile touch controls
   - Add French/English translations"
   ```

4. **Push and create PR**
   ```bash
   git push origin feature/new-awesome-game
   # Create PR on GitHub with detailed description
   ```

### PR Template
Use this template for your pull request:
```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
- [ ] Tested with multiple players
- [ ] Tested on mobile simulation
- [ ] Tested language switching

## Screenshots/Videos
Include visual evidence of your changes

## Additional Notes
Any additional context or considerations
```

## 🎯 Priority Areas

We especially welcome contributions in these areas:

### High Priority
- **New Mini-Games:** Pong, Memory Match, Racing
- **Mobile Polish:** Performance optimizations, better touch controls
- **Audio System:** Music and sound effects
- **AI Opponents:** Single-player modes

### Medium Priority
- **Tournament System:** Bracket-style competitions
- **Player Statistics:** Track wins/losses
- **Chat System:** In-game communication
- **Spectator Mode:** Watch ongoing games

### Low Priority
- **Additional Languages:** Spanish, German, etc.
- **Themes:** Alternative UI themes
- **Accessibility:** Color-blind friendly options
- **Achievements:** Game accomplishments

## ❓ Getting Help

- **Questions:** Open a GitHub Discussion
- **Bugs:** Create a GitHub Issue  
- **Documentation:** Check [Testing Guide](docs/TESTING_GUIDE.md) or [Server Setup](docs/SERVER_SETUP_GUIDE.md)
- **Code Standards:** See examples in existing scripts

## 🏆 Recognition

Contributors will be:
- Listed in project credits
- Mentioned in release notes
- Given collaborator access for significant contributions

Thank you for helping make Mini Games Online better! 🎮
