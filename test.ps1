Add-Type -AssemblyName PresentationFramework

while ($true) {
    [System.Windows.MessageBox]::Show("Dit is een test bericht van Pieter")


    $configPath = Join-Path $PSScriptRoot "test.json"

    $config = Get-Content -Path $configPath -Raw | ConvertFrom-Json
    
    $logFolder = $config.LogFolder
    
    $timestamp = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"
    $logPath = Join-Path $logFolder "update-log_$timestamp.txt"


    "Het script is gelukt op $timestamp" | Out-File -FilePath $logPath -Encoding UTF8

    Start-Sleep -Seconds 10
}