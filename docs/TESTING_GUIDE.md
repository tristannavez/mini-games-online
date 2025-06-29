# 🧪 Testing Guide - Mini Games Online

## 🎯 How to Test the Game

### 1. 🚀 Quick Launch
```powershell
# Multiple desktop instances
.\tools\launch_multiplayer_test.ps1

# Advanced mobile device simulator (recommended)
.\tools\mobile_device_simulator.ps1 -Device Android -DualDevice
```

### 2. 📱 Mobile Device Simulation

#### Advanced Mobile Simulator (Recommended)
```powershell
# Interactive device selection menu
.\tools\mobile_device_simulator.ps1

# Specific device testing
.\tools\mobile_device_simulator.ps1 -Device iPhone -Orientation Portrait
.\tools\mobile_device_simulator.ps1 -Device Android -Orientation Landscape
.\tools\mobile_device_simulator.ps1 -Device iPad -NetworkLatency 4G
```

#### Advanced Mobile Simulator
```powershell
# Interactive device selection
.\tools\mobile_device_simulator.ps1

# Specific device testing
.\tools\mobile_device_simulator.ps1 -Device iPhone -Orientation Portrait
.\tools\mobile_device_simulator.ps1 -Device Android -Orientation Landscape

# Dual device multiplayer testing
.\tools\mobile_device_simulator.ps1 -Device iPad -DualDevice

# Performance monitoring
.\tools\mobile_device_simulator.ps1 -Device Android -PerformanceMonitor
```

#### Mobile Testing Features
- **Touch Emulation**: Mouse clicks simulate finger touches
- **Realistic Resolutions**: iPhone 12/13, Pixel 6, iPad Air profiles
- **Orientation Testing**: Portrait and landscape modes
- **Network Simulation**: WiFi, 4G, 3G latency simulation
- **DPI Scaling**: High-DPI display simulation

### 3. 🎮 Multiplayer Testing Instructions

#### On Instance 1 (Host)
1. **Enter your name**: e.g., "Player1"
2. **Test language switching**: Click "🌐 English" / "🌐 Français"
3. **Click "🎮 Host Game"**
4. **Get the game code** displayed (currently shows "GAME123" as placeholder)
5. **Wait in lobby** for the client to connect

#### On Instance 2 (Client)  
1. **Enter your name**: e.g., "Player2"
2. **Change language if desired**: Test EN/FR
3. **Click "🔗 Join Game"**
4. **Enter the game code** from the host (e.g., "GAME123")
5. **Click "OK"** to join

#### In the Lobby (both players)
1. **Verify** both players are listed
2. **Click "✅ Ready"** on each instance
3. **Select "⭕ Tic-Tac-Toe"**
4. **Click "🚀 Start Game"** when all are ready

#### In the Tic-Tac-Toe game
1. **Player X starts** (usually the host)
2. **Click on squares** to place X or O
3. **Turn changes automatically**
4. **Win by aligning 3 symbols**

## 🔍 Checklist

### ✅ Modern UI/UX
- [ ] **Dark theme** with rounded borders
- [ ] **Buttons with shadows** and hover effects
- [ ] **Smooth animations** (scale, fade)
- [ ] **100% responsive interface** without scroll
- [ ] **Automatic adaptation** to all screen sizes
#### In Lobby (Both Players)
1. **Enter your name** in the player name field
2. **Click "✅ Ready"** on both instances
3. **Select Game**: Choose "⭕ Tic-Tac-Toe"
4. **Host clicks "🚀 Start Game"**

#### In Game
1. **Take turns**: Players alternate X and O
2. **Check win detection**: Try to get 3 in a row
3. **Test "🔄 New Game"** after completion
4. **Test "🏠 Back to Lobby"** to return

---

## ✅ Checklist - What to Verify

### ✅ UI/Visual
- [ ] **Modern dark theme** with cyan accents
- [ ] **Smooth transitions** between scenes
- [ ] **Responsive layout** - no scrolling on mobile simulation
- [ ] **Emoji icons** in buttons
- [ ] **French/English language system** working properly

### ✅ Mobile/Touch
- [ ] **Sufficiently large buttons** (50px+ height)
- [ ] **No scrolling** - everything fits on screen
- [ ] **Touch feedback** on interactions
- [ ] **Perfect readability** even at 400x700
- [ ] **Intuitive navigation** without mouse
- [ ] **Adaptive game grid** (TicTacToe mobile-friendly)
- [ ] **Easy language switching** with dedicated button

### ✅ Network/Multiplayer
- [ ] **Stable host/client connection**
- [ ] **"Ready" status synchronization**
- [ ] **Real-time** in Tic-Tac-Toe game
- [ ] **Graceful disconnect handling**
- [ ] **Clear error messages**

### ✅ Performance
- [ ] **Quick startup** (< 5 seconds)
- [ ] **Smooth transitions** between scenes
- [ ] **No lag** in interactions
- [ ] **Stable memory** during gameplay

## 📱 Mobile-Specific Testing Checklist

### 🎯 Mobile UI Testing
- [ ] **Touch Targets**: All buttons are easily tappable (44pt minimum)
- [ ] **Text Readability**: All text is legible at mobile resolutions
- [ ] **Element Spacing**: UI elements don't overlap or feel cramped
- [ ] **Landscape/Portrait**: Interface adapts correctly to orientation changes
- [ ] **Safe Areas**: Content respects device safe areas (notches, etc.)

### 🔄 Mobile Interaction Testing
- [ ] **Touch Responsiveness**: Buttons respond immediately to taps
- [ ] **Scroll Behavior**: Smooth scrolling in menus and lists
- [ ] **Input Fields**: Virtual keyboard integration works properly
- [ ] **Gesture Support**: Basic touch gestures work as expected
- [ ] **Multi-touch**: No issues with accidental multi-touch

### 📊 Mobile Performance Testing
- [ ] **Frame Rate**: Maintains 60fps on mobile devices
- [ ] **Battery Usage**: Reasonable power consumption
- [ ] **Memory Usage**: No memory leaks during extended play
- [ ] **Network Efficiency**: Minimal data usage for multiplayer
- [ ] **Loading Times**: Quick app startup and game loading

### 🌐 Mobile Network Testing
- [ ] **WiFi**: Stable connection on strong WiFi
- [ ] **4G/5G**: Works on mobile data connections
- [ ] **Poor Signal**: Graceful handling of weak connections
- [ ] **Connection Loss**: Recovery from temporary disconnections
- [ ] **Background/Foreground**: Handles app switching properly

### 📱 Device Profile Testing
| Device Type | Resolution | DPI | Orientation | Status |
|-------------|------------|-----|-------------|--------|
| iPhone 12/13 | 390x844 | 460 | Portrait | ⬜ |
| iPhone 12/13 | 844x390 | 460 | Landscape | ⬜ |
| Pixel 6 | 411x891 | 411 | Portrait | ⬜ |
| Pixel 6 | 891x411 | 411 | Landscape | ⬜ |
| iPad Air | 820x1180 | 264 | Portrait | ⬜ |
| iPad Air | 1180x820 | 264 | Landscape | ⬜ |

## 📊 Expected Results

### 🎯 Test Successful If:
1. **Both instances launch** without crash
2. **Multiplayer connection** works with game codes
3. **Modern UI** displays correctly  
4. **Tic-Tac-Toe game** is playable by two players
5. **Animations** are smooth
6. **100% responsive interface** - no visible scrolling
7. **Mobile simulation** shows perfectly adapted UI
8. **Language system** works (FR/EN, saves preference)
9. **Return to lobby** puts players back to "Not Ready"
10. **Game abandonment**: Other player sees "Player left the game" and can return to lobby

### 🎨 Visual Test Example
```
Desktop (800x600)          Mobile (400x700)
┌─────────────────┐        ┌──────────┐
│  [  Title  ]    │        │[ Title ] │
│                 │        │          │
│ [ Panel  ]      │   VS   │[Panel ]  │
│ [ Central]      │        │[Central] │
│                 │        │          │
│ [  Actions ]    │        │[Actions] │
└─────────────────┘        └──────────┘
```
✅ **No more scrolling** - everything adapts automatically!

## 🎁 Bonus Features

### 🌐 Language System
- **Language button**: "🌐 English" or "🌐 Français" 
- **Instant switching**: All texts update immediately
- **Auto-save**: Preference is remembered
- **Full support**: MainMenu, Lobby, TicTacToe

### 🎮 Advanced Tests
- **Disconnect during game**: Player closes window
- **Return to lobby**: Click "🏠 Back to Lobby" during game
- **Window resizing**: Enlarge/reduce windows
- **Multi-matches**: Launch several consecutive games
- **Stress test**: Click rapidly everywhere
- **Language test**: Change language at different moments

### 📱 Real Mobile Tests
If you export to Android/iOS:
- **Precise touch** on buttons
- **Virtual keyboard** for name input
- **Screen rotation** (if enabled)
- **Performance** on mobile hardware

---

**🎯 Ready to test? Launch `.\tools\mobile_device_simulator.ps1` and have fun!**
