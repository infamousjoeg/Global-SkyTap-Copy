function Set-SkyTapAuth ([string]$username, [string]$password) {
    
    # Base64 Encode username:api-key for Authentication header
    $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username,$password)))

    $base64AuthInfo
}

function Set-TemplateCopy ([string]$basic_auth, [int]$template_id, [string]$target_region, [bool]$copy_override=$true) {
    
    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/templates.json"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    $body = @{
        "template_id" = $template_id
        "target_region" = $target_region
        "copy_to_region_vm_status_override" = $copy_override
    } | ConvertTo-Json

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method POST -Body $body -ContentType "application/json" -Headers $headers

}

function Set-TemplateOwner ([string]$basic_auth, [int]$template_id, [string]$owner) {
    
    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/${template_id}.json"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    $body = @{
        "owner" = "80356"
    } | ConvertTo-Json

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method PUT -Body $body -ContentType "application/json" -Headers $headers

}

function Set-TemplateName ([string]$basic_auth, [int]$template_id, [string]$new_name) {

    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/template/${template_id}?name=${new_name}"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method PUT -ContentType "application/json" -Headers $headers

}

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

foreach ($region in $ConfigFile.Settings.Template.Regions) {
    
    $responseCopyTemplate = Set-TemplateCopy -basic_auth $base64AuthInfo -template_id $ConfigFile.Settings.Template.CopyID -target_region $region

    if ($responseCopyTemplate) {

        Write-Host $responseCopyTemplate -ForegroundColor Green
        
        # Set variables based on response values
        $responseCopyId = $responseCopyTemplate.id
        $responseCopyName = $responseCopyTemplate.name
        $responseCopyRegion = $responseCopyTemplate.region

        if ($responseCopyId) {
            Write-Host "[ Step 1/3 ] Template successfully queued for copy!" -ForegroundColor Cyan
        } else {
            Write-Host "An error occurred while attempting to copy the template via API." - -ForegroundColor Red
        }

        # Begin owner change process

        # Begin name change process

    } else {
        Write-Host "No response was received from the API call." -ForegroundColor Red
    }

    

}

Write-Host " "
Write-Host "================================================================" -ForegroundColor Yellow
Write-Host " "
Write-Host "Script finished."