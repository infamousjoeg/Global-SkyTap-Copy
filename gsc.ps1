Import-Module PoShSkyTap

$chkPSModule = Get-Module PoShSkyTap

if ($chkPSModule.Version) {
    Write-Host "PoShSkyTap is installed." -ForegroundColor Yellow
    Write-Host "Version Installed:" $chkPSModule.Version -ForegroundColor Yellow
} else {
    Write-Host "PoShSkyTap was not installed successfully." -ForegroundColor Red
}