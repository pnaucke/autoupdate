Add-Type -AssemblyName PresentationFramework

while ($true) {
    [System.Windows.MessageBox]::Show("Dit is een test bericht van Pieter")

    # Maak een bestandsnaam met timestamp
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $filename = "C:\PerfLogs\script_success_$timestamp.txt"

    # Schrijf een bericht naar het bestand
    "Het script is gelukt op $timestamp" | Out-File -FilePath $filename -Encoding UTF8

    Start-Sleep -Seconds 300
}