Import-Module "${pwd}\SkyTapAPI.psm1" | Out-Null

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

# Use TLS 1.2 rather than PowerShell default of 1.0
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Import XML Configuration Settings
[xml]$ConfigFile = Get-Content "config.xml"

# Base64 Encode username:api-key for Authentication header
$base64AuthInfo = Set-SkyTapAuth -username $ConfigFile.Settings.Authentication.SkyTapAPIUser -password $ConfigFile.Settings.Authentication.SkyTapAPIPass

# Loop through each <Region> in config.xml
foreach ($region in $ConfigFile.Settings.Template.Regions) {
    
    # Loop through each <Environment> in config.xml
    foreach ($env in $ConfigFile.Settings.Template.Environments) {

        # Set error flag to null for "No error"
        $errFlag = $null

        # Begin copy template process
        $responseCopyTemplate = Set-TemplateCopy -basic_auth $base64AuthInfo -template_id $ConfigFile.Settings.Template.CopyID -target_region $region

        if ($responseCopyTemplate) {
            
            Write-Host $responseCopyTemplate -ForegroundColor Green
            
            # Set variables based on response values
            $responseCopyId = $responseCopyTemplate.id
            $responseCopyName = $responseCopyTemplate.name

            if ($responseCopyId) {
                Write-Host "[ Step 1/4 ] Template successfully queued for copy" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to copy the template via API." -ForegroundColor Red
                $errFlag = 1
            }

            # Begin owner change process
            $responseChangeOwner = Set-TemplateOwner -basic_auth $base64AuthInfo -template_id $responseCopyId -target_owner $ConfigFile.Settings.Template.NewOwnerID

            if ($responseChangeOwner -and !$errFlag) {
                Write-Host "[ Step 2/4 ] Owner successfully updated to ${ConfigFile.Settings.Template.NewOwnerID}" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to change the owner via API." -ForegroundColor Red
                $errFlag = 1
            }

            # Begin name change process
            $copyNameBase = $responseCopyName.TrimStart("US ")
            $copyNameBase = $copyNameBase.TrimEnd(" - Copy")
            $copyNewName = "${region} ${copyNameBase}"
            
            $responseChangeName = Set-TemplateName -basic_auth $base64AuthInfo -template_id $responseCopyId -new_name $copyNewName

            if ($responseChangeName -and !$errFlag) {
                Write-Host "[ Step 3/4 ] Name of template successfully updated to ${copyNewName}" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to change the name of the template via API." -ForegroundColor Red
                $errFlag = 1
            }

            # Set Project Tag for pulling ID from config.xml
            $projectTag = "${region}${env}"
            
            # Add template to proper project for distribution
            $responseChangeProject = Set-TemplateProject -basic_auth $base64AuthInfo -template_id $responseCopyId -project_id $ConfigFile.Settings.Template.Projects.${projectTag}

            if ($responseChangeProject -and !$errFlag) {
                Write-Host "[ Step 4/4 ] Template successfully added to the ${region} CyberArk Global Demo ${env} Project" -ForegroundColor Cyan
            } else {
                Write-Host "An error occurred while attempting to add the template to a project via API." -ForegroundColor Red
                $errFlag = 1
            }

        } else {
            Write-Host "No response was received from the API call." -ForegroundColor Red
        }

    }

}

Write-Host " "
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host " "
Write-Host "Script finished."