const express = require('express');
const cors = require('cors');
const app = express();
const port = 8080;

// Storage for games (in production, use a database)
let games = {};

// Middleware
app.use(cors());
app.use(express.json());

// Clean up old games every 5 minutes
setInterval(() => {
    const now = Date.now() / 1000;
    for (const [code, game] of Object.entries(games)) {
        if (now - game.created_at > 1800) { // 30 minutes
            delete games[code];
            console.log(`Cleaned up expired game: ${code}`);
        }
    }
}, 5 * 60 * 1000);

// Register a new game
app.post('/api/games', (req, res) => {
    try {
        const { game_data } = req.body;
        
        if (!game_data || !game_data.code) {
            return res.status(400).json({ error: 'Invalid game data' });
        }
        
        // Validate game data
        if (!game_data.host_name || game_data.host_name.length > 20) {
            return res.status(400).json({ error: 'Invalid host name' });
        }
        
        if (game_data.max_players > 8 || game_data.max_players < 1) {
            return res.status(400).json({ error: 'Invalid max players' });
        }
        
        games[game_data.code] = {
            ...game_data,
            registered_at: Date.now() / 1000
        };
        
        console.log(`Game registered: ${game_data.code} by ${game_data.host_name}`);
        res.json({ 
            action: 'game_registered', 
            success: true,
            game_code: game_data.code
        });
        
    } catch (error) {
        console.error('Error registering game:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get list of public games
app.get('/api/games', (req, res) => {
    try {
        const gamesList = Object.values(games).filter(game => !game.is_private);
        res.json({ 
            action: 'games_list', 
            games: gamesList,
            count: gamesList.length
        });
    } catch (error) {
        console.error('Error fetching games:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get specific game info
app.get('/api/games/:code', (req, res) => {
    try {
        const { code } = req.params;
        const game = games[code];
        
        if (!game) {
            return res.status(404).json({ error: 'Game not found' });
        }
        
        res.json({ 
            action: 'game_info', 
            game: game 
        });
    } catch (error) {
        console.error('Error fetching game info:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Update game player count
app.put('/api/games/:code', (req, res) => {
    try {
        const { code } = req.params;
        const { current_players } = req.body;
        
        if (!games[code]) {
            return res.status(404).json({ error: 'Game not found' });
        }
        
        games[code].current_players = current_players;
        
        console.log(`Game ${code} updated: ${current_players} players`);
        res.json({ 
            action: 'game_updated', 
            success: true 
        });
        
    } catch (error) {
        console.error('Error updating game:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Unregister a game
app.delete('/api/games', (req, res) => {
    try {
        const { game_code } = req.body;
        
        if (!game_code || !games[game_code]) {
            return res.status(404).json({ error: 'Game not found' });
        }
        
        delete games[game_code];
        console.log(`Game unregistered: ${game_code}`);
        
        res.json({ 
            action: 'game_unregistered', 
            success: true 
        });
        
    } catch (error) {
        console.error('Error unregistering game:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({ 
        status: 'healthy', 
        games_count: Object.keys(games).length,
        uptime: process.uptime()
    });
});

// Start server
app.listen(port, () => {
    console.log(`🎮 Mini Games Matchmaking Server running on port ${port}`);
    console.log(`📊 Health check: http://localhost:${port}/health`);
});

// Graceful shutdown
process.on('SIGTERM', () => {
    console.log('Shutting down gracefully...');
    process.exit(0);
});
