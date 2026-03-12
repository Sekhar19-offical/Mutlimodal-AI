
# Script to Map a False .com Domain to Localhost
# Run this script as Administrator to access your app via 'www.my-local-ai.com' on THIS machine only.

$domain = "www.my-local-ai.com"
$backend = "api.my-local-ai.com"
$ip = "127.0.0.1"
$hostsFile = "$env:windir\System32\drivers\etc\hosts"

Write-Host "Setting up local domain simulation..." -ForegroundColor Cyan

# Check if already exists
$content = Get-Content $hostsFile
if ($content -match $domain) {
    Write-Host "Domain $domain already mapped in hosts file." -ForegroundColor Yellow
} else {
    try {
        Add-Content -Path $hostsFile -Value "`n$ip       $domain"
        Add-Content -Path $hostsFile -Value "$ip       $backend"
        Write-Host "Success! Mapped $domain to 127.0.0.1" -ForegroundColor Green
    } catch {
        Write-Error "Failed to write to hosts file. Please run PowerShell as Administrator."
        exit
    }
}

Write-Host "`nNext Steps:" -ForegroundColor White
Write-Host "1. Open your browser."
Write-Host "2. Go to http://$domain:3000 (Frontend)"
Write-Host "3. The Backend is at http://$backend:8000"
Write-Host "`nNOTE: This only works on YOUR computer. To make it real for everyone, you must buy the domain." -ForegroundColor Gray
