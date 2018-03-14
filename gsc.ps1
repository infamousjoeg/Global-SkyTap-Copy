Import-Module PoShSkyTap

$chkPSModule = Get-Module PoShSkyTap

if ($chkPSModule.Version) {
    Write-Host "PoShSkyTap is installed." -ForegroundColor Yellow
    Write-Host "Version Installed:" $chkPSModule.Version -ForegroundColor Yellow
} else {
    Write-Host "PoShSkyTap was not installed successfully." -ForegroundColor Red
}

#[xml]ConfigFile = Get-Content -Path "skytap.cred.xml"
#$authSkyTap = Set-SkyTapAuth -Username $ConfigFile.SkyTap.Credentials.Username -APIKey $ConfigFile.SkyTap.Credentials.Password

Write-Host $(Read-Host "Enter any input for return")