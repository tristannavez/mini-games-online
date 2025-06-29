# Script to launch multiple game instances for testing
param(
    [int]$instances = 2
)

$godotPath = "D:\Softwares\Godot_v4.4.1-stable_win64.exe"
$projectPath = "."

Write-Host "Launching $instances game instances..." -ForegroundColor Green

for ($i = 1; $i -le $instances; $i++) {
    $x = 100 + (($i - 1) * 850)
    $y = 100
    
    Write-Host "Launching instance $i (Position: $x,$y)" -ForegroundColor Yellow
    
    Start-Process -FilePath $godotPath -ArgumentList "--path", $projectPath, "--rendering-driver", "opengl3", "--position", "$x,$y", "--resolution", "800x600", "--windowed"
    
    # Wait a bit between launches
    Start-Sleep -Seconds 1
}

Write-Host "All instances launched!" -ForegroundColor Green
Write-Host "Instance 1: Create a server" -ForegroundColor Cyan
Write-Host "Instance 2+: Join the server (IP: 127.0.0.1)" -ForegroundColor Cyan

