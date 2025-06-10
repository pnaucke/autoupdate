Start-Sleep -Seconds 120  # Wacht 2 minuten na het opstarten

# Map voor de applicatie
$installPath = "C:\Users\Public\AutoUpdater"
if (-not (Test-Path $installPath)) {
    New-Item -ItemType Directory -Path $installPath -Force
}

# URLs van de bestanden op GitHub
$scriptUrl = "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.ps1"
$jsonUrl = "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.json"

# Bestandslocaties na download
$scriptPath = Join-Path $installPath "autoupdate.ps1"
$jsonPath = Join-Path $installPath "autoupdater.json"

# Download de bestanden van GitHub
Invoke-WebRequest -Uri $scriptUrl -OutFile $scriptPath
Invoke-WebRequest -Uri $jsonUrl -OutFile $jsonPath

# Voer het update-script uit
PowerShell -ExecutionPolicy Bypass -File $scriptPath