Write-Host "================================================================" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host "   ______ _        _______             _______                  " -ForegroundColor Cyan
Write-Host "  / _____) |      (_______)           (_______)                 " -ForegroundColor Cyan
Write-Host " ( (____ | |  _ _   _| |_____ ____    | |      ___  ____  _   _ " -ForegroundColor Cyan
Write-Host "  \____ \| |_/ ) | | | (____ |  _ \   | |     / _ \|  _ \| | | |" -ForegroundColor Cyan
Write-Host "  _____) )  _ (| |_| | / ___ | |_| |  | |____| |_| | |_| | |_| |" -ForegroundColor Cyan
Write-Host " (______/|_| \_)\__  |_\_____|  __/    \______)___/|  __/ \__  |" -ForegroundColor Cyan
Write-Host "               (____/        |_|                   |_|   (____/ " -ForegroundColor Cyan
Write-Host " "
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host " "
Write-Host "Please check config.xml for accuracy before"
Read-Host  "pressing any button to continue..."
Write-Host " "
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host " "

# Declare and set variables

$ErrorActionPreference = Stop

# Check for required PoShSkyTap PowerShell module
## Available on PowerShell Gallery at https://www.powershellgallery.com/packages/PoShSkyTap

if (!(Get-Module PoShSkyTap -ListAvailable)) {

    # PowerShell Version greater than 5
    if ($PSVersionTable.PSVersion.Major -ge 5) {
    
        try {

            Install-Module -Name "PoShSkyTap"

        } catch {

            $errorMessage = $_.Exception.Message
            
            Write-Host "[ERROR] ${errorMessage}" -ForegroundColor Red
            Write-Host "-----" -ForegroundColor Yellow
            Write-Host "Failed to install required PoShSkyTap PowerShell module from https://www.powershellgallery.com/packages/PoShSkyTap" -ForegroundColor Red
            Write-Host "Please manually install the PowerShell module before continuing."
            Read-Host "Press any key to exit..."

            Break

        }

        try {

            Import-Module -Name "PoShSkyTap"

        } catch {

            $errorMessage = $_.Exception.Message
            
            Write-Host "[ERROR] ${errorMessage}" -ForegroundColor Red
            Write-Host "-----" -ForegroundColor Yellow
            Write-Host "Failed to import required PoShSkyTap PowerShell module using Import-Module command." -ForegroundColor Red
            Read-Host "Press any key to exit..."

            Break

        }

    } else {

            Write-Host "Please install the PowerShell module PoShSkyTap before continuing."
            Write-Host "You can find it on PowerShell Gallery at https://www.powershellgallery.com/packages/PoShSkyTap"
            Read-Host "Press any key to exit..."

    } 

} else {

    try {

        Import-Module -Name "PoShSkyTap"

    } catch {

        $errorMessage = $_.Exception.Message
        
        Write-Host "[ERROR] ${errorMessage}" -ForegroundColor Red
        Write-Host "-----" -ForegroundColor Yellow
        Write-Host "Failed to import required PoShSkyTap PowerShell module using Import-Module command." -ForegroundColor Red
        Read-Host "Press any key to exit..."

        Break

    }

}

# Use TLS 1.2 rather than PowerShell default of 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Import XML Configuration Settings
[xml]$ConfigFile = Get-Content "config.xml"

# Base64 Encode username:api-key for Authentication header
$base64AuthInfo = Set-SkyTapAuth -Username $ConfigFile.Settings.SkyTap.Authentication.SkyTapAPIUser -APIKey $ConfigFile.Settings.SkyTap.Authentication.SkyTapAPIPass

# Iterate each region
foreach ($region in $ConfigFile.Settings.SkyTap.Templates) {
    
    # Iterate each environment
    foreach ($environment in $ConfigFile.Settings.SkyTap.Templates.${region}) {
        
        # Begin copying template via REST API
        $responseCopyTemplate = Set-TemplateCopy -SkyTapAuth $base64AuthInfo -TemplateID $ConfigFile.Settings.SkyTap.Templates.$region.$environment.TemplateID -TargetRegion $region

        # If a response is returned...
        if ($responseCopyTemplate) {

            Write-Host $responseCopyTemplate -ForegroundColor Green
            
            # Set variables based on response values
            $responseCopyId = $responseCopyTemplate.id
            #$responseCopyName = $responseCopyTemplate.name
            #$responseCopyRegion = $responseCopyTemplate.region

            # If a Template ID is found, we're queued...
            if ($responseCopyId) {
                Write-Host "[ Step 1/4 ] Template successfully queued for copy!" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to copy the template via API." -ForegroundColor Red
            }

            # Begin owner change process
            $newOwnerID = $ConfigFile.Settings.SkyTap.Templates.$region.$environment.OwnerID

            $responseOwnerChange = Set-TemplateOwner -SkyTapAuth $base64AuthInfo -TemplateID $responseCopyId -OwnerID $newOwnerID
            
            if ($responseOwnerChange.owner -eq "https://cloud.skytap.com/users/${newOwnerID}") {
                Write-Host "[ Step 2/4 ] Changed owner successfully!" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to change the owner via API." -ForegroundColor Red
            }

            # Begin name change process
            $newTemplateName = "${region} CyberArk Global Demo ${environment}"
            $responseNameChange = Set-TemplateName -SkyTapAuth $base64AuthInfo -TemplateID $responseCopyId -TemplateName $newTemplateName

            if ($responseNameChange.name -eq $newTemplateName) {
                Write-Host "[ Step 3/4 ] Changed template name successfully!" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to change the template name via API." -ForegroundColor Red
            }

            # Begin add to proper Project
            $newProjectID = $ConfigFile.Settings.SkyTap.Templates.$region.$environment.ProjectID
            $responseProjectChange = Set-TemplateProject -SkyTapAuth $base64AuthInfo -TemplateID $responseCopyId -ProjectID $newProjectID

            if ($responseProjectChange.id -eq $responseCopyId) {
                Write-Host "[ Step 4/4 ] Changed template project successfully!" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to change the project ID via API." -ForegroundColor Red
            }

            Write-Host "[ FINISHED ] Successfully copied $newTemplateName" -ForegroundColor Green

        } else {
            Write-Host "No response was received from the API call." -ForegroundColor Red
        }

    }

}

Write-Host " "
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host " "
Write-Host "Script finished." -ForegroundColor Green