@echo off
echo ===============================================
echo    Mini Games Online - Production Build
echo ===============================================
echo.

REM Configuration
set GODOT_PATH="D:\Softwares\Godot_v4.4.1-stable_win64.exe"
set PROJECT_PATH=%cd%
set BUILD_DIR=builds
set VERSION=1.0.0

echo 🎮 Building Mini Games Online v%VERSION%
echo 📂 Project path: %PROJECT_PATH%
echo 🔨 Godot path: %GODOT_PATH%
echo.

REM Verify Godot exists
if not exist %GODOT_PATH% (
    echo ❌ Error: Godot not found at %GODOT_PATH%
    echo Please update the GODOT_PATH variable in this script
    pause
    exit /b 1
)

REM Create builds directory
echo 📁 Creating builds directory...
if not exist %BUILD_DIR% mkdir %BUILD_DIR%

REM Clean previous builds
echo 🧹 Cleaning previous builds...
del /Q "%BUILD_DIR%\*" 2>nul

echo.
echo 🚀 Starting build process...
echo.

REM Build Windows Desktop
echo ⚙️ Building Windows Desktop version...
%GODOT_PATH% --headless --export-release "Windows Desktop" "%BUILD_DIR%/MiniGamesOnline_v%VERSION%_Windows.exe"
if %errorlevel% neq 0 (
    echo ❌ Windows build failed!
    goto :error
)
echo ✅ Windows build completed

REM Build Linux
echo ⚙️ Building Linux version...
%GODOT_PATH% --headless --export-release "Linux/X11" "%BUILD_DIR%/MiniGamesOnline_v%VERSION%_Linux.x86_64"
if %errorlevel% neq 0 (
    echo ❌ Linux build failed!
    goto :error
)
echo ✅ Linux build completed

REM Optional: Build Android (uncomment if Android export is configured)
REM echo ⚙️ Building Android version...
REM %GODOT_PATH% --headless --export-release "Android" "%BUILD_DIR%/MiniGamesOnline_v%VERSION%_Android.apk"
REM if %errorlevel% neq 0 (
REM     echo ❌ Android build failed!
REM     goto :error
REM )
REM echo ✅ Android build completed

echo.
echo ===============================================
echo ✅ BUILD COMPLETED SUCCESSFULLY!
echo ===============================================
echo.
echo 📦 Built files:
dir /B "%BUILD_DIR%\"
echo.
echo 📍 Location: %PROJECT_PATH%\%BUILD_DIR%\
echo.
echo 🎯 Next steps:
echo   1. Test the builds on target platforms
echo   2. Create installers/packages
echo   3. Upload to distribution platforms
echo   4. Update version control tags
echo.

REM Create a simple README for the builds
echo Creating build information...
(
echo Mini Games Online v%VERSION%
echo Built on: %date% %time%
echo.
echo Files in this directory:
echo - MiniGamesOnline_v%VERSION%_Windows.exe  ^(Windows 10+^)
echo - MiniGamesOnline_v%VERSION%_Linux.x86_64 ^(Linux Ubuntu 18.04+^)
echo.
echo System Requirements:
echo - 2GB RAM minimum
echo - OpenGL 3.3 support
echo - Internet connection for multiplayer
echo.
echo For support: Check PRODUCTION_GUIDE.md
) > "%BUILD_DIR%\README.txt"

goto :end

:error
echo.
echo ===============================================
echo ❌ BUILD FAILED!
echo ===============================================
echo.
echo Please check:
echo   1. Godot path is correct
echo   2. Export presets are configured
echo   3. All export templates are installed
echo   4. Project has no compilation errors
echo.
pause
exit /b 1

:end
echo Press any key to open builds folder...
pause > nul
explorer "%BUILD_DIR%"
