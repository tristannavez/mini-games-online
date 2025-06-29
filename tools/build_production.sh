#!/bin/bash

echo "==============================================="
echo "   Mini Games Online - Production Build"
echo "==============================================="
echo

# Configuration
GODOT_PATH="/usr/local/bin/godot"  # Adjust path as needed
PROJECT_PATH=$(pwd)
BUILD_DIR="builds"
VERSION="1.0.0"

echo "🎮 Building Mini Games Online v$VERSION"
echo "📂 Project path: $PROJECT_PATH"
echo "🔨 Godot path: $GODOT_PATH"
echo

# Verify Godot exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "❌ Error: Godot not found at $GODOT_PATH"
    echo "Please update the GODOT_PATH variable in this script"
    echo "You can install Godot with: sudo apt install godot3-server (Linux)"
    exit 1
fi

# Create builds directory
echo "📁 Creating builds directory..."
mkdir -p "$BUILD_DIR"

# Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -f "$BUILD_DIR"/*

echo
echo "🚀 Starting build process..."
echo

# Build Windows Desktop
echo "⚙️ Building Windows Desktop version..."
"$GODOT_PATH" --headless --export-release "Windows Desktop" "$BUILD_DIR/MiniGamesOnline_v${VERSION}_Windows.exe"
if [ $? -ne 0 ]; then
    echo "❌ Windows build failed!"
    exit 1
fi
echo "✅ Windows build completed"

# Build Linux
echo "⚙️ Building Linux version..."
"$GODOT_PATH" --headless --export-release "Linux/X11" "$BUILD_DIR/MiniGamesOnline_v${VERSION}_Linux.x86_64"
if [ $? -ne 0 ]; then
    echo "❌ Linux build failed!"
    exit 1
fi
echo "✅ Linux build completed"

# Build macOS (if on macOS or cross-compilation is set up)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "⚙️ Building macOS version..."
    "$GODOT_PATH" --headless --export-release "macOS" "$BUILD_DIR/MiniGamesOnline_v${VERSION}_macOS.dmg"
    if [ $? -ne 0 ]; then
        echo "❌ macOS build failed!"
        exit 1
    fi
    echo "✅ macOS build completed"
fi

echo
echo "==============================================="
echo "✅ BUILD COMPLETED SUCCESSFULLY!"
echo "==============================================="
echo

echo "📦 Built files:"
ls -la "$BUILD_DIR/"
echo

echo "📍 Location: $PROJECT_PATH/$BUILD_DIR/"
echo

echo "🎯 Next steps:"
echo "  1. Test the builds on target platforms"
echo "  2. Create installers/packages"
echo "  3. Upload to distribution platforms"
echo "  4. Update version control tags"
echo

# Create a simple README for the builds
echo "Creating build information..."
cat > "$BUILD_DIR/README.txt" << EOF
Mini Games Online v$VERSION
Built on: $(date)

Files in this directory:
- MiniGamesOnline_v${VERSION}_Windows.exe  (Windows 10+)
- MiniGamesOnline_v${VERSION}_Linux.x86_64 (Linux Ubuntu 18.04+)

System Requirements:
- 2GB RAM minimum
- OpenGL 3.3 support
- Internet connection for multiplayer

For support: Check PRODUCTION_GUIDE.md
EOF

echo "🎉 Build process completed!"

# Make the Linux build executable
chmod +x "$BUILD_DIR"/*.x86_64 2>/dev/null

echo "Press Enter to open builds folder..."
read
if command -v xdg-open > /dev/null; then
    xdg-open "$BUILD_DIR"
elif command -v open > /dev/null; then
    open "$BUILD_DIR"
fi
