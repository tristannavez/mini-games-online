# 🎮 Mini Games Online

**A modern cross-platform multiplayer mini-games collection built with Godot 4.4.1**

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Linux%20%7C%20Android-green.svg)
![Language](https://img.shields.io/badge/language-English%20%7C%20French-yellow.svg)
![Multiplayer](https://img.shields.io/badge/multiplayer-Cross--platform-red.svg)

## 🌟 Overview

Mini Games Online is a beautiful, modern multiplayer gaming platform that brings people together through classic mini-games. Built with Godot 4.4.1, it features cross-platform compatibility, stunning UI design, and seamless online multiplayer functionality.

## ✨ Key Features

### 🎮 Core Gaming
- **Cross-platform multiplayer** - Play with friends on any device
- **TicTacToe** - Classic strategy game with real-time synchronization
- **Game lobbies** - Organized player management and game selection
- **Public & Private sessions** - Host open games or play with friends using codes

### 🎭 Personalization
- **Player names** - Personalized player identification
- **Real-time sync** - See other players instantly
- **Visual representation** - Players displayed throughout the game

### 🌐 Connectivity
- **Easy hosting** - One-click game creation with shareable codes
- **Quick joining** - Enter 4-digit codes to join friends
- **Auto-discovery** - Browse and join public games
- **Stable networking** - Robust connection handling

### 🎨 User Experience
- **Modern UI** - Dark theme with smooth animations
- **Responsive design** - Perfect on desktop, tablet, and mobile
- **Multi-language** - Full English and French support
- **Touch optimized** - Mobile-friendly controls and layouts

## 🚀 Quick Start

### For Players

1. **Download** the game for your platform
2. **Enter your name** in the main menu
3. **Host or Join:**
   - **Host Game:** Create public or private sessions
   - **Join Game:** Enter a friend's code or browse public games
4. **Ready up** in the lobby and start playing!

### System Requirements

**Minimum:**
- OS: Windows 10 / Ubuntu 18.04 / Android 6.0
- RAM: 2GB
- Graphics: OpenGL 3.3 support
- Network: Internet connection for multiplayer

## 🏗️ Project Structure

```
mini_games_online/
├── 📁 assets/           # Game assets (themes, icons)
├── 📁 scenes/           # Main game scenes and UI
├── 📁 scripts/          # Core system scripts (autoloads)
├── 📁 minigames/        # Individual mini-game implementations
├── 📁 docs/             # Essential documentation
├── 📁 tools/            # Development and build scripts
├── 📁 server/           # Optional matchmaking server
└── 📁 .vscode/          # Development environment configuration
```

## 🛠️ Development

### Prerequisites
- **Godot 4.4.1** - Game engine
- **Git** - Version control
- **Node.js** - For matchmaking server (optional)

### Setup
```bash
git clone [repository-url]
cd mini_games_online
# Open project.godot in Godot Editor
```

### Building
```bash
# Windows
tools\build_production.bat

# Linux/macOS
./tools/build_production.sh
```

### Testing

**Direct Testing Commands:**
```powershell
# Multiple desktop instances for testing
.\tools\launch_multiplayer_test.ps1       # Standard multiplayer testing

# Advanced mobile device simulation
.\tools\mobile_device_simulator.ps1       # Interactive device selection
```

**Mobile Testing:**
```powershell
# Advanced mobile device simulator (recommended)
.\tools\mobile_device_simulator.ps1                             # Interactive menu
.\tools\mobile_device_simulator.ps1 -Device iPhone -DualDevice  # iPhone dual testing
.\tools\mobile_device_simulator.ps1 -Device Android -Orientation Landscape # Android landscape
.\tools\mobile_device_simulator.ps1 -Device iPad -NetworkLatency 4G # iPad with network simulation
```

**Testing Scripts Overview:**
| Script | Purpose | Location |
|--------|---------|----------|
| `launch_multiplayer_test.ps1` | Multiple instances launcher | tools/ |
| `mobile_device_simulator.ps1` | Advanced device simulator | tools/ |
| `build_production.bat/.sh` | Production builds | tools/ |

**Tools Folder Summary:**
| File | Purpose | Features |
|------|---------|----------|
| `build_production.bat` | Windows production builds | Cross-platform exports |
| `build_production.sh` | Linux/macOS production builds | Automated build process |
| `launch_multiplayer_test.ps1` | Multiple desktop instances | Standard multiplayer testing |
| `mobile_device_simulator.ps1` | Advanced mobile simulation | Device profiles, orientations, network simulation |

**VS Code Tasks Available:**
- `Test: Advanced Mobile Simulator` - Full interactive device simulator
- `Test: Dual Mobile Devices (Android)` - Test multiplayer on Android devices
- `Test: Mobile Simulator (iPhone)` - iPhone-specific dual device testing
- `Test: Mobile Simulator (iPad)` - iPad-specific dual device testing
- `Test: Multiple Instances` - Launch multiple desktop instances

## 📚 Documentation

| Document | Description |
|----------|-------------|
| [Testing Guide](docs/TESTING_GUIDE.md) | Comprehensive testing procedures and guidelines |
| [Server Setup](docs/SERVER_SETUP_GUIDE.md) | Matchmaking server configuration and deployment |
| [Contributing Guidelines](CONTRIBUTING.md) | How to contribute to the project |

## 🏛️ Architecture

The project follows a clean, modular architecture:

### Core Systems (Autoloads)
- **NetworkManager** - Multiplayer networking and connections
- **GameManager** - Game state management and flow control
- **UIManager** - Interface animations and notifications
- **LanguageManager** - Internationalization and localization

### Design Patterns
- **Singleton pattern** for managers
- **Signal-based communication** between components
- **MVC separation** for UI and game logic
- **Modular mini-game system** for easy expansion

## 📱 Mobile Development

### Mobile-First Design
The project is built with cross-platform compatibility in mind:
- **Touch-friendly UI** with appropriate button sizes
- **Responsive layouts** that adapt to different screen sizes
- **Portrait and landscape** orientation support
- **Touch emulation** for desktop testing

### Mobile Testing Tools
We provide comprehensive mobile simulation tools:

#### Basic Mobile Simulation
#### Advanced Device Simulator (Recommended)
- `mobile_device_simulator.ps1` - Interactive device selection
- Multiple device profiles (iPhone 12/13, Pixel 6, iPad Air, etc.)
- Portrait/landscape orientation testing
- Network latency simulation (WiFi, 4G, 3G)
- Performance monitoring options
- Dual device testing for multiplayer

### Mobile Considerations
- **Minimum touch target size**: 44pt/px recommended
- **Text readability** at mobile resolutions
- **Network optimization** for mobile connections
- **Battery efficiency** considerations
- **Platform-specific UI guidelines** (iOS/Android)

### Real Device Testing
While simulators are great for development, always test on real devices:
- Export builds for Android/iOS
- Test on various device sizes
- Verify touch responsiveness
- Check performance on lower-end devices

## 🎯 Roadmap

### Completed ✅
- Core multiplayer framework
- TicTacToe mini-game
- Multi-language support
- Cross-platform builds

### Planned 🚧
- Additional mini-games
- Tournament system
- Player statistics

## 🤝 Contributing

We welcome contributions! Please read our contributing guidelines and submit pull requests for any improvements.

### Development Guidelines
- Follow GDScript best practices
- Use type hints where possible
- Document public methods
- Test on multiple platforms
- Maintain responsive design principles

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

- 📖 Check the [documentation](docs/)
- 🐛 Report bugs via issues
- 💬 Join our community discussions
- 📧 Contact the development team

---

**Built with ❤️ using Godot 4.4.1**

## 🏗️ Architecture

The project follows a modular architecture with singletons (autoloads) to manage different aspects of the game:

- **NetworkManager**: Handles all multiplayer network connectivity
- **GameManager**: Coordinates mini-games and game states
- **UIManager**: Manages UI transitions, animations and interface elements
- **LanguageManager**: Handles French/English localization

## 🚀 Installation and Launch

### Prerequisites
- **Godot 4.4.1** or newer
- Supported platforms: Windows, macOS, Linux, Android, iOS

### 🎯 Quick Start
1. **Open** the project in Godot 4.4.1+
2. **Launch** the main scene: `res://scenes/MainMenu.tscn` (F5)
3. **Test** with multi-instance using VS Code tasks

### 🧪 Local Multiplayer Testing
#### With VS Code (recommended)
```
Ctrl+Shift+P → "Tasks: Run Task" → "Launch Multiple Instances for Testing"
```

#### With PowerShell
```powershell
# Multiple instances testing
.\tools\launch_multiplayer_test.ps1

# Advanced mobile testing (interactive)
.\tools\mobile_device_simulator.ps1
```

### 🎮 How to Play
#### Host a Game
1. **Enter** your player name
2. **Click** "🎮 Host Game"
3. **Share** the game code with friends
4. **Wait** for players to join the lobby

#### Join a Game
1. **Enter** your player name  
2. **Click** "🔗 Join Game"
3. **Enter** the game code provided by the host
4. **Join** the multiplayer lobby

## 🎮 Available Mini-Games

### ⭕ Tic-Tac-Toe
- **👥 Players**: 2
- **🎯 Objective**: Align 3 symbols (X or O) horizontally, vertically or diagonally
- **🎮 Controls**: Mouse click or touch on squares
- **📱 Mobile**: 112x112px buttons, perfectly touch-friendly
- **✨ Features**: Smooth animations, visual feedback, victory detection

## 🛠️ Development

### 📁 Modern File Structure
```
mini_games_online/
├── 📄 project.godot              # Godot project configuration
├── 🎨 assets/                    # Resources and themes
│   ├── modern_theme.tres         # Modern UI theme
│   └── icon.svg                  # Application icon
├── 🎬 scenes/                    # Main scenes
│   ├── MainMenu.tscn/gd         # Responsive main menu
│   └── Lobby.tscn/gd            # Multiplayer lobby
├── 📜 scripts/                   # Manager scripts (autoloads)
│   ├── NetworkManager.gd        # Multiplayer network management
│   ├── GameManager.gd           # Game states and coordination
│   ├── UIManager.gd             # UI animations and transitions
│   └── LanguageManager.gd       # Localization management
├── 🎮 minigames/                # Mini-games folder
│   └── tictactoe/               # Complete Tic-Tac-Toe mini-game
├── 🔧 .vscode/                  # VS Code configuration
│   ├── tasks.json               # Multi-instance test tasks
│   └── settings.json            # Godot Tools settings
```

### ➕ Adding a New Mini-Game
1. **Create** a folder in `minigames/gameName/`
2. **Implement** the `.tscn` scene with responsive UI
3. **Code** the `.gd` script with multiplayer support
4. **Add** the type in `GameManager.GameType`
5. **Configure** the path in `get_game_scene_path()`
6. **Integrate** the button in the lobby with emoji icon
7. **Apply** modern theme and animations

### 📱 Mobile UI Guidelines
- **Minimum sizes**: Buttons 50px+, touch areas 44px+
- **Spacing**: Margins 16-24px, separations 12-16px
- **Responsive design**: Always for scrollable content using `CenterContainer` + `VBoxContainer`
- **CenterContainer**: To center panels
- **Modern theme**: Apply `modern_theme.tres`
- **Animations**: Use `UIManager.setup_modern_buttons_in_container()`

### 🎨 UI Code Standards
```gdscript
# Typical responsive scene structure
CenterContainer
└── MainContainer (VBoxContainer)
	├── TopSpacer (Control, min_size: 20-50px)
	├── CenterContainer
	│   └── ContentPanel (Panel, min_size: 400-500px)
	│       └── MarginContainer (margins: 24-32px)
	│           └── VBoxContainer (separation: 16-24px)
	└── BottomSpacer (Control, min_size: 20-50px)
```

### 📋 Coding Standards
- **Primary language**: GDScript with type hints
- **Godot 4.x conventions**: Following official documentation
- **Naming**: `snake_case` variables/functions, `PascalCase` classes/scenes
- **Documentation**: Comments for public methods
- **Type hints**: `var player_name: String`, `func get_score() -> int`
- **Error handling**: Try/catch for network operations
- **Signals**: Communication between components
- **Modularity**: Clear separation of responsibilities

## 📱 Cross-Platform Compatibility

### ✅ Supported Platforms
- **💻 Desktop**: Windows, macOS, Linux (native)
- **📱 Mobile**: Android, iOS (touch-optimized UI)
- **🌐 Web**: HTML5 via Godot export (network limitations)

### 🎮 Platform Adaptations
#### Mobile
- **Responsive UI**: CenterContainer + centered panels
- **Large buttons**: 50-60px minimum height
- **Touch feedback**: Ripple effects and animations
- **Orientation**: Auto-adaptive portrait/landscape
- **Performance**: Mobile-specific optimizations

#### Desktop  
- **Hover effects**: Mouse hover animations
- **Keyboard shortcuts**: Quick navigation
- **Multi-window**: Support for multi-instance testing
- **High resolution**: Adaptive scaling

#### Web
- **Compression**: Optimized assets for web
- **Local network**: Possible WebRTC limitations
- **Performance**: Browser-adapted rendering mode

## 🤝 Contributing

Contributions are welcome! To contribute:

1. **🍴 Fork** the project on GitHub
2. **🌿 Create** a feature branch (`git checkout -b feature/new-minigame`)
3. **💻 Develop** following mobile UI guidelines
4. **🧪 Test** on desktop AND mobile (simulation)
5. **📝 Commit** your changes (`git commit -am 'Add new mini-game'`)
6. **📤 Push** the branch (`git push origin feature/new-minigame`)
7. **🔄 Create** a detailed Pull Request

### 🎯 Priority Contributions
- **🎮 New mini-games**: Additional games to be determined
- **📱 Mobile optimizations**: Performance, UI, controls
- **🎵 Audio system**: Music and sound effects
- **🌍 Internationalization**: Multi-language support
- **🤖 AI**: Single-player modes with bots

## 📄 License

This project is under **MIT License**. Free to use, modify and distribute!

## 🆘 Support and Help

- **🐛 Bugs**: Use [GitHub Issues](https://github.com/your-repo/issues)
- **💡 Suggestions**: Propose new features
- **❓ Questions**: Check documentation or open an issue
- **📖 Wiki**: Detailed architecture documentation

---

## 🎯 Project Status

### ✅ Current version: v1.0 - "Modern UI"
- ✅ **Modern and responsive interface** 
- ✅ **Mobile and touch optimization**
- ✅ **Complete multiplayer Tic-Tac-Toe**
- ✅ **Advanced lobby system**
- ✅ **Robust modular architecture**
- ✅ **Multilingual support (FR/EN)**
- ✅ **Game code system for easy hosting/joining**

### 🚀 Next version: v1.1 - "Expanded Features"
- 🎯 **Additional mini-games to be determined**
- 🎯 **Complete audio system**
- 🎯 **Mobile export Android/iOS**

**🎮 Ready to play? Launch the game and challenge your friends!**
