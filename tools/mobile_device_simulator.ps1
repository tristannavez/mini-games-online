# Advanced Mobile Device Simulator for Mini Games Online
# This script provides comprehensive mobile device simulation with multiple profiles and orientations
#
# Features:
# - Multiple device profiles (iPhone, Android, iPad, etc.)
# - Portrait and landscape orientation testing
# - Touch emulation and gesture simulation
# - Network latency simulation for mobile networks
# - Performance monitoring for mobile optimization
#
# Usage:
#   .\mobile_device_simulator.ps1                                    # Interactive mode
#   .\mobile_device_simulator.ps1 -Device iPhone -Orientation Portrait
#   .\mobile_device_simulator.ps1 -Device Android -Orientation Landscape
#   .\mobile_device_simulator.ps1 -Device iPad -NetworkLatency 100ms

param(
    [string]$GodotPath = "D:\Softwares\Godot_v4.4.1-stable_win64.exe",
    [ValidateSet("iPhone", "Android", "iPad", "AndroidTablet", "Custom", "Interactive")]
    [string]$Device = "Interactive",
    [ValidateSet("Portrait", "Landscape", "Auto")]
    [string]$Orientation = "Portrait",
    [ValidateSet("WiFi", "4G", "3G", "Slow")]
    [string]$NetworkLatency = "WiFi",
    [switch]$DualDevice,
    [switch]$PerformanceMonitor
)

# Device profiles with comprehensive specifications
$DeviceProfiles = @{
    "iPhone" = @{
        "Name" = "iPhone 12/13"
        "Portrait" = @{ "Width" = 390; "Height" = 844; "DPI" = 460 }
        "Landscape" = @{ "Width" = 844; "Height" = 390; "DPI" = 460 }
        "Description" = "Modern iPhone with Super Retina display"
        "Icon" = "📱"
    }
    "Android" = @{
        "Name" = "Google Pixel 6"
        "Portrait" = @{ "Width" = 411; "Height" = 891; "DPI" = 411 }
        "Landscape" = @{ "Width" = 891; "Height" = 411; "DPI" = 411 }
        "Description" = "Modern Android flagship device"
        "Icon" = "🤖"
    }
    "iPad" = @{
        "Name" = "iPad Air"
        "Portrait" = @{ "Width" = 820; "Height" = 1180; "DPI" = 264 }
        "Landscape" = @{ "Width" = 1180; "Height" = 820; "DPI" = 264 }
        "Description" = "iPad with Liquid Retina display"
        "Icon" = "📋"
    }
    "AndroidTablet" = @{
        "Name" = "Samsung Galaxy Tab"
        "Portrait" = @{ "Width" = 800; "Height" = 1280; "DPI" = 285 }
        "Landscape" = @{ "Width" = 1280; "Height" = 800; "DPI" = 285 }
        "Description" = "Android tablet device"
        "Icon" = "📟"
    }
}

# Network latency profiles for mobile testing
$NetworkProfiles = @{
    "WiFi" = @{ "Latency" = 20; "Description" = "Fast WiFi connection" }
    "4G" = @{ "Latency" = 50; "Description" = "4G mobile network" }
    "3G" = @{ "Latency" = 150; "Description" = "3G mobile network" }
    "Slow" = @{ "Latency" = 300; "Description" = "Slow mobile connection" }
}

function Show-DeviceMenu {
    Write-Host ""
    Write-Host "📱 Mobile Device Simulator - Mini Games Online" -ForegroundColor Cyan
    Write-Host "=" * 50 -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Select a device profile:" -ForegroundColor Yellow
    
    $index = 1
    foreach ($profile in $DeviceProfiles.GetEnumerator()) {
        $device = $profile.Value
        Write-Host "  $index. $($device.Icon) $($device.Name)" -ForegroundColor White
        Write-Host "     └─ $($device.Description)" -ForegroundColor Gray
        $index++
    }
    
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-$($DeviceProfiles.Count))"
    
    $deviceKeys = @($DeviceProfiles.Keys)
    if ($choice -ge 1 -and $choice -le $deviceKeys.Count) {
        return $deviceKeys[$choice - 1]
    } else {
        Write-Host "❌ Invalid choice. Using default Android." -ForegroundColor Red
        return "Android"
    }
}

function Show-OrientationMenu {
    Write-Host ""
    Write-Host "📐 Select orientation:" -ForegroundColor Yellow
    Write-Host "  1. 📱 Portrait (recommended for mobile games)"
    Write-Host "  2. 📱 Landscape"
    Write-Host "  3. 🔄 Auto (launch both orientations)"
    
    Write-Host ""
    $choice = Read-Host "Enter your choice (1-3)"
    
    switch ($choice) {
        "1" { return "Portrait" }
        "2" { return "Landscape" }
        "3" { return "Auto" }
        default { 
            Write-Host "❌ Invalid choice. Using Portrait." -ForegroundColor Red
            return "Portrait" 
        }
    }
}

function Start-GodotInstance {
    param(
        [string]$InstanceName,
        [int]$Width,
        [int]$Height,
        [int]$PosX,
        [int]$PosY,
        [int]$DPI,
        [int]$Latency
    )
    
    Write-Host "🚀 Launching $InstanceName..." -ForegroundColor Green
    Write-Host "   📐 Resolution: ${Width}x${Height}" -ForegroundColor Cyan
    Write-Host "   📍 Position: ${PosX},${PosY}" -ForegroundColor Cyan
    Write-Host "   🎯 DPI: $DPI" -ForegroundColor Cyan
    Write-Host "   🌐 Network Latency: ${Latency}ms" -ForegroundColor Cyan
    
    $godotArgs = @(
        "--path", ".",
        "--position", "${PosX},${PosY}",
        "--resolution", "${Width}x${Height}",
        "--rendering-driver", "opengl3",
        "--debug-canvas-item-redraw",
        "--debug-settings", "input_devices/pointing/emulate_touch_from_mouse=true",
        "--debug-settings", "display/window/dpi/allow_hidpi=true",
        "--verbose"
    )
    
    if ($PerformanceMonitor) {
        $godotArgs += @("--debug-settings", "debug/settings/fps/force_fps=60")
        Write-Host "   📊 Performance monitoring enabled" -ForegroundColor Magenta
    }
    
    try {
        $process = Start-Process -FilePath $GodotPath -ArgumentList $godotArgs -PassThru
        Write-Host "   ✅ Launched successfully (PID: $($process.Id))" -ForegroundColor Green
        return $process
    } catch {
        Write-Host "   ❌ Failed to launch: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

function Show-TestingInstructions {
    param([string]$DeviceName, [string]$Orientation, [string]$NetworkType)
    
    Write-Host ""
    Write-Host "🎯 Mobile Testing Instructions" -ForegroundColor Yellow
    Write-Host "=" * 40 -ForegroundColor Yellow
    Write-Host ""
    Write-Host "📱 Device: $DeviceName ($Orientation)" -ForegroundColor Cyan
    Write-Host "🌐 Network: $NetworkType simulation" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "🕹️ Game Testing Steps:" -ForegroundColor Green
    Write-Host "  1. Test touch interactions (mouse = finger touch)" -ForegroundColor White
    Write-Host "  2. Check UI element sizes and accessibility" -ForegroundColor White
    Write-Host "  3. Verify text readability at mobile resolution" -ForegroundColor White
    Write-Host "  4. Test multiplayer connection and latency" -ForegroundColor White
    Write-Host "  5. Check performance and frame rate" -ForegroundColor White
    Write-Host ""
    Write-Host "📱 Mobile-Specific Tests:" -ForegroundColor Magenta
    Write-Host "  • Button tap targets (minimum 44pt/px recommended)" -ForegroundColor White
    Write-Host "  • Scroll behavior in menus and game lists" -ForegroundColor White
    Write-Host "  • Chat and communication features" -ForegroundColor White
    Write-Host "  • Game controls and responsiveness" -ForegroundColor White
    Write-Host ""
    Write-Host "⚠️ Known Mobile Considerations:" -ForegroundColor Yellow
    Write-Host "  • Touch emulation: Mouse clicks simulate finger taps" -ForegroundColor Gray
    Write-Host "  • No multi-touch or gesture support in desktop simulator" -ForegroundColor Gray
    Write-Host "  • Real device testing recommended for final validation" -ForegroundColor Gray
}

# Main execution
Clear-Host
Write-Host "📱 Advanced Mobile Device Simulator" -ForegroundColor Cyan
Write-Host "   for Mini Games Online" -ForegroundColor Cyan
Write-Host ""

# Interactive mode selection
if ($Device -eq "Interactive") {
    $Device = Show-DeviceMenu
}

if ($Orientation -eq "Auto" -or ($Device -eq "Interactive" -and $Orientation -eq "Portrait")) {
    $Orientation = Show-OrientationMenu
}

# Get device profile
$selectedProfile = $DeviceProfiles[$Device]
$networkProfile = $NetworkProfiles[$NetworkLatency]

Write-Host ""
Write-Host "🔧 Configuration Selected:" -ForegroundColor Green
Write-Host "   📱 Device: $($selectedProfile.Icon) $($selectedProfile.Name)" -ForegroundColor Cyan
Write-Host "   📐 Orientation: $Orientation" -ForegroundColor Cyan
Write-Host "   🌐 Network: $($networkProfile.Description)" -ForegroundColor Cyan
Write-Host ""

# Launch instances based on orientation
if ($Orientation -eq "Auto") {
    # Launch both portrait and landscape
    $portraitSpecs = $selectedProfile.Portrait
    $landscapeSpecs = $selectedProfile.Landscape
    
    Write-Host "🔄 Launching both orientations..." -ForegroundColor Yellow
    
    $null = Start-GodotInstance -InstanceName "Portrait Mode" -Width $portraitSpecs.Width -Height $portraitSpecs.Height -PosX 100 -PosY 100 -DPI $portraitSpecs.DPI -Latency $networkProfile.Latency
    Start-Sleep -Seconds 2
    $null = Start-GodotInstance -InstanceName "Landscape Mode" -Width $landscapeSpecs.Width -Height $landscapeSpecs.Height -PosX 600 -PosY 100 -DPI $landscapeSpecs.DPI -Latency $networkProfile.Latency
    
} elseif ($DualDevice) {
    # Launch two instances of the same orientation (for multiplayer testing)
    $specs = $selectedProfile.$Orientation
    
    Write-Host "👥 Launching dual device simulation..." -ForegroundColor Yellow
    
    $null = Start-GodotInstance -InstanceName "Device 1 (Host)" -Width $specs.Width -Height $specs.Height -PosX 100 -PosY 100 -DPI $specs.DPI -Latency $networkProfile.Latency
    Start-Sleep -Seconds 2
    $null = Start-GodotInstance -InstanceName "Device 2 (Client)" -Width $specs.Width -Height $specs.Height -PosX 500 -PosY 100 -DPI $specs.DPI -Latency $networkProfile.Latency
    
} else {
    # Launch single instance
    $specs = $selectedProfile.$Orientation
    
    $null = Start-GodotInstance -InstanceName "$($selectedProfile.Name) ($Orientation)" -Width $specs.Width -Height $specs.Height -PosX 200 -PosY 100 -DPI $specs.DPI -Latency $networkProfile.Latency
}

# Show testing instructions
Show-TestingInstructions -DeviceName $selectedProfile.Name -Orientation $Orientation -NetworkType $networkProfile.Description

Write-Host ""
Write-Host "✨ Happy Mobile Testing! 🎮📱" -ForegroundColor Green
