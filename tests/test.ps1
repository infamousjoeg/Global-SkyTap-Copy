Import-Module PoShSkyTap

$chkPSModule = Get-Module PoShSkyTap

if ($chkPSModule.Version) {
    Write-Host "PoShSkyTap is installed." -ForegroundColor Yellow
    Write-Host "Version Installed:" $chkPSModule.Version -ForegroundColor Yellow
} else {
    Write-Host "PoShSkyTap was not installed successfully." -ForegroundColor Red
}

if ($env:SKYTAP_USER -and $env:SKYTAP_PASS -and $env:SKYTAP_REGION -and $env:SKYTAP_USER -ne "****" -and $env:SKYTAP_PASS -ne "****") {
    $authToken = Set-SkyTapAuth -Username $env:SKYTAP_USER -APIKey $env:SKYTAP_PASS
    if ($authToken) {
        Write-Host "SkyTap API Authorization Token is: ${authToken}" -ForegroundColor Green
        Write-Host "The targeted region is: ${env:SKYTAP_REGION}" -ForegroundColor Yellow
    } else {
        Write-Host "Authorization failed." -ForegroundColor Red
    }
} else {
    Write-Host "No SKYTAP_USER or SKYTAP_PASS environment variables found." -ForegroundColor Red
}
