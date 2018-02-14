Import-Module PoShSkyTap

$chkPSModule = Get-Module PoShSkyTap

if ($chkPSModule.Version) {
    Write-Host "PoShSkyTap is installed." -ForegroundColor Yellow
    Write-Host "Version Installed:" $chkPSModule.Version -ForegroundColor Yellow
} else {
    Write-Host "PoShSkyTap was not installed successfully." -ForegroundColor Red
}

if ($env:SKYTAP_USER && $env:SKYTAP_PASS) {
    $authToken = Set-SkyTapAuth -Username $env:SKYTAP_USER -Password $env:SKYTAP_PASS
    if ($authToken) {
        Write-Host "SkyTap API Authorization Token is: ${authToken}" -ForegroundColor Green
    } else {
        Write-Host "Authorization failed." -ForegroundColor Red
    }
} else {
    Write-Host "No SKYTAP_USER or SKYTAP_PASS environment variables found." -ForegroundColor Red
}
