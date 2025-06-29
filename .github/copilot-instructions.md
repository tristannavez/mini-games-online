<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# Mini Games Online - Copilot Instructions

This is a cross-platform multiplayer mini-games project built with Godot 4.4.1.

## Project Guidelines

- Use GDScript as the primary language
- Follow Godot 4.x conventions and best practices
- Implement multiplayer functionality using Godot's built-in networking
- Ensure cross-platform compatibility (Windows, macOS, Linux, Android, iOS)
- Focus on clean, maintainable code with proper separation of concerns
- Use signals for communication between components
- Implement proper error handling for network operations

## Architecture

- **NetworkManager**: Handles all multiplayer networking (server/client)
- **GameManager**: Manages game states and mini-game coordination
- **UIManager**: Handles UI transitions and overlays
- **Mini-games**: Each mini-game is a separate scene with its own controller

## Coding Standards

- Use snake_case for variables and functions
- Use PascalCase for class names and scene names
- Add proper documentation for public methods
- Use type hints where possible
- Implement proper resource management
