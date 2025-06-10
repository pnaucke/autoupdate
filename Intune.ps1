Start-Sleep -Seconds 10  # Wacht

$scriptPath = "$env:TEMP\autoupdate.ps1"
$jsonPath = "$env:TEMP\autoupdater.json"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.ps1" -OutFile $scriptPath
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.json" -OutFile $jsonPath

PowerShell -ExecutionPolicy Bypass -File $scriptPath