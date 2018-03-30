Import-Module PoShSkyTap

if (!$(Get-Module PoShSkyTap).Version) {
    Write-Host "PoShSkyTap was not installed successfully." -ForegroundColor Red
    exit
}

[xml]$ConfigFile = Get-Content -Path "/etc/gsc/skytap.cred.xml"
$authSkyTap = Set-SkyTapAuth -Username $ConfigFile.SkyTap.Credentials.Username -APIKey $ConfigFile.SkyTap.Credentials.Password

# User Input
Write-Host "--------------------------" - -ForegroundColor Yellow
$masterTemplateID = Read-Host "Please enter the master Template's ID"
$targetRegion = Read-Host "Please enter region to copy to [ US-East | US-Central | EMEA* | APAC ]"
if (!$targetRegion) { $targetRegion = "EMEA" }
elseif ($targetRegion -ne "US-East" -and $targetRegion -ne "US-Central" -and $targetRegion -ne "EMEA" -and $targetRegion -ne "APAC") { Write-Host "Choose correctly."; exit }
$targetEnv = Read-Host "Please enter the environment to copy to [ DEV | QA* | GA ]"
if (!$targetEnv) { $targetEnv = "QA" }
elseif ($targetEnv -ne "GA" -and $targetEnv -ne "DEV" -and $targetEnv -ne "QA") { Write-Host "Choose correctly."; exit }

# Start Template Copy
$r_TemplateCopy = Set-TemplateCopy -SkyTapAuth $authSkyTap -TemplateID $masterTemplateID -TargetRegion $targetRegion

$copyTemplateID = $r_TemplateCopy.id

if (!$copyTemplateID) { Write-Host "Error occured trying to start copy."; exit}

Write-Host "Copy process started.  New Template ID: ${copyTemplateID}" - -ForegroundColor Green

# Set Template Name
$r_TemplateName = Set-TemplateName -SkyTapAuth $authSkyTap -TemplateID $copyTemplateID -TemplateName "${targetRegion} CyberArk Global Demo v10_${targetEnv}"

$copyTemplateName = $r_TemplateName.name

if ($copyTemplateName) { Write-Host "Set template name to: ${copyTemplateName}" -ForegroundColor Green }
else { Write-Host "Template name not set correctly."; exit }

# Set Template Owner
switch ($targetRegion) {
    "US-East" { $ownerID = "279622" }
    "US-Central" { $ownerID = "279522" }
    "EMEA" { $ownerID = "279620" }
    "APAC" { $ownerID = "279618" }
}

$r_TemplateOwner = Set-TemplateOwner -SkyTapAuth $authSkyTap -TemplateID $copyTemplateID -OwnerID $ownerID

$copyOwnerID = $r_TemplateOwner.owner

Write-Host "Set Owner to: ${copyOwnerID}" -ForegroundColor Green

switch ($targetRegion) {
    "US-East" {
        switch ($targetEnv) {
            "DEV" { $projectID = "112666" }
            "QA" { $projectID = "102336" }
            "GA" { $projectID = "102338" }
        }
    }
    "US-Central" {
        switch ($targetEnv) {
            "DEV" { $projectID = "112666" }
            "QA" { $projectID = "102336" }
            "GA" { $projectID = "102338" }
        }
    }
    "EMEA" {
        switch ($targetEnv) {
            "DEV" { $projectID = "112668" }
            "QA" { $projectID = "102356" }
            "GA" { $projectID = "102348" }
        }
    }
    "APAC" {
        switch ($targetEnv) {
            "DEV" { $projectID = "112670" }
            "QA" { $projectID = "102350" }
            "GA" { $projectID = "102346" }
        }
    }
}

$r_TemplateProject = Set-TemplateProject -SkyTapAuth $authSkyTap -TemplateID $copyTemplateID -ProjectID $projectID

$projectName = $r_TemplateProject.name 

Write-Host "Added template to project: ${projectName}" -ForegroundColor Green

Write-Host "--------------------------" -ForegroundColor Yellow

Write-Host "New template can be found at: https://cloud.skytap.com/templates/${copyTemplateID}" -ForegroundColor Cyan

Write-Host "Script complete." -ForegroundColor Yellow