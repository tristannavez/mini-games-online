# Conventional Commits Guide for Mini Games Online

## Commit Message Format

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

## Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests or correcting existing tests
- **chore**: Changes to the build process or auxiliary tools
- **ci**: Changes to CI configuration files and scripts
- **build**: Changes that affect the build system or external dependencies

## Scopes

- **tictactoe**: Tic-Tac-Toe mini-game
- **network**: Networking/multiplayer system
- **lobby**: Lobby system
- **ui**: User interface
- **i18n**: Internationalization
- **build**: Build system
- **tools**: Development tools
- **server**: Matchmaking server
- **docs**: Documentation

## Examples

```bash
feat(tictactoe): add victory animation
fix(network): resolve connection timeout issue
docs(readme): update installation instructions
refactor(lobby): simplify player list management
chore(build): update Godot export presets
ci(github): add automated testing workflow
build(tools): update build scripts for cross-platform
perf(ui): optimize button rendering performance
test(network): add multiplayer connection tests
style(lobby): fix indentation in player list code
```
