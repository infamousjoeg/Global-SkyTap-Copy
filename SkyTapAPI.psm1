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

function Set-TemplateOwner ([string]$basic_auth, [int]$template_id, [string]$target_owner) {
    
    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/templates/${template_id}.json"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    $body = @{
        "owner" = "${target_owner}"
    } | ConvertTo-Json

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method PUT -Body $body -ContentType "application/json" -Headers $headers

}

function Set-TemplateName ([string]$basic_auth, [int]$template_id, [string]$new_name) {

    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/templates/${template_id}?name=${new_name}"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method PUT -ContentType "application/json" -Headers $headers

}

function Set-TemplateProject ([string]$basic_auth, [int]$template_id, [int]$project_id) {

    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/projects/${project_id}/templates/${template_id}"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method POST -ContentType "application/json" -Headers $headers

}

function Remove-TemplateProject ([string]$basic_auth, [int]$template_id, [int]$project_id) {

    # Set URI endpoint to send call to
    $uri = "https://cloud.skytap.com/projects/${project_id}/templates/${template_id}"

    # Set headers required for authentication and format
    $headers = @{"Accept" = "application/json"; Authorization=("Basic {0}" -f $basic_auth)}

    # Send the API call
    Invoke-RestMethod -Uri $uri -Method DEL -ContentType "application/json" -Headers $headers

}

Export-ModuleMember -Function Set-SkyTapAuth
Export-ModuleMember -Function Set-TemplateCopy
Export-ModuleMember -Function Set-TemplateName
Export-ModuleMember -Function Set-TemplateOwner
Export-ModuleMember -Function Set-TemplateProject
Export-ModuleMember -Function Remove-TemplateProject
