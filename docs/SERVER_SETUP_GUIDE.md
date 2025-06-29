# 🌐 Matchmaking Server Setup Guide

This guide explains how to configure and use a matchmaking server to host online games.

## 📋 Hosting Options

### Option 1: Local Test Server
```gdscript
# In your code, enable local server
NetworkManager.configure_matchmaking_server("http://localhost:8080", true)
```

### Option 2: Cloud Server (Recommended)
```gdscript
# Replace with your server URL
NetworkManager.configure_matchmaking_server("https://your-server.com", true)
```

### Option 3: Cloud Gaming Services
- **Epic Online Services** (free)
- **Steam Steamworks** (if on Steam)
- **Photon** (third-party service)

## 🛠️ Simple Node.js Server

Create a basic server with Node.js + Express:

```javascript
const express = require('express');
const app = express();
const port = 8080;

let games = {};

app.use(express.json());

// Register a game
app.post('/api/games', (req, res) => {
    const gameData = req.body.game_data;
    games[gameData.code] = gameData;
    res.json({ action: 'game_registered', success: true });
});

// Get games list
app.get('/api/games', (req, res) => {
    const gamesList = Object.values(games);
    res.json({ action: 'games_list', games: gamesList });
});

// Remove a game
app.delete('/api/games', (req, res) => {
    const gameCode = req.body.game_code;
    delete games[gameCode];
    res.json({ action: 'game_unregistered', success: true });
});

app.listen(port, () => {
    console.log(`Matchmaking server started on port ${port}`);
});
```

## 🔧 Configuration in Godot

### 1. Enable Matchmaking Server
```gdscript
# In MainMenu.gd, add in _ready()
NetworkManager.configure_matchmaking_server("https://your-server.com", true)
```

### 2. Development Configuration
```gdscript
# For local testing
NetworkManager.configure_matchmaking_server("http://localhost:8080", true)
```

### 3. Disable for Local Testing
```gdscript
# Keep local system
NetworkManager.configure_matchmaking_server("", false)
```

## 🌍 Recommended Cloud Hosting

### Free Services
- **Heroku** (with limitations)
- **Railway** (generous free plan)
- **Render** (free plan available)
- **Vercel** (for serverless APIs)

### Paid Services
- **DigitalOcean** (~$5/month)
- **AWS EC2** (variable)
- **Google Cloud** (variable)
- **Azure** (variable)

## 🔒 Security

### Important Points
1. **HTTPS** required in production
2. **Validation** of server-side data
3. **Rate limiting** to prevent spam
4. **Player authentication**
5. **Filtering** inappropriate games

### Validation Example
```javascript
function validateGameData(gameData) {
    return gameData.code && 
           gameData.host_name && 
           gameData.max_players <= 8 &&
           gameData.host_name.length <= 20;
}
```

## 🎮 Usage

### Creating a Public Game
1. Game automatically registers the game on the server
2. Other players can see it in "Browse Public Games"
3. Connection is made directly to the creator's IP

### Joining a Game
1. Game retrieves the list from the server
2. Displays available games
3. Connects directly to the game host

## 🔧 Troubleshooting

### Common Issues
- **Firewall**: Open port 7000 TCP
- **NAT**: Configure port forwarding
- **CORS**: Configure server headers
- **Public IP**: Use IP detection service

### Useful Logs
```gdscript
# Enable network logs in Godot
print("Connecting to: ", server_ip, ":", server_port)
```

## 📈 Future Improvements

1. **Player authentication**
2. **Game statistics**
3. **Skill-based matchmaking**
4. **Global chat**
5. **Friends** and invitations
6. **Organized tournaments**
