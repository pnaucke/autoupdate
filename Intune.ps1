Start-Sleep -Seconds 10  # Wacht

$scriptPath = "$env:TEMP\autoupdate.ps1"
$jsonPath = "$env:TEMP\autoupdater.json"

Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.ps1" -OutFile $scriptPath
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/pnaucke/autoupdate/refs/heads/main/autoupdater.json" -OutFile $jsonPath

PowerShell -ExecutionPolicy Bypass -File $scriptPath

# Controleer of PSWindowsUpdate is geïnstalleerd
if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
    Write-Output "PSWindowsUpdate module niet geïnstalleerd. Installeren..."
    Install-Module -Name PSWindowsUpdate -Force
} else {
    Write-Output "PSWindowsUpdate module al geïnstalleerd."
}

# Controleer de Execution Policy en pas indien nodig aan
$currentPolicy = Get-ExecutionPolicy
if ($currentPolicy -ne "Bypass") {
    Write-Output "Execution Policy is ingesteld op $currentPolicy. Wijzigen naar Bypass..."
    Set-ExecutionPolicy Bypass -Force
} else {
    Write-Output "Execution Policy staat al op Bypass."
}