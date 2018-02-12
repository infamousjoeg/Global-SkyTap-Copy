# Global-SkyTap-Copy

### CyberArk Global Corp SE Team's Global SkyTap Copy

Automated SkyTap Master Template copy to necessary regions and environments.

Be sure to change [config.template.xml](config.template.xml) to `config.xml` and update the settings within before running the Docker container.

## Current Development Status

### Initial Test Release

```docker
docker build -t nfmsjoeg/gsc:latest .
docker run -it --name gsc nfmsjoeg/gsc:latest
```

###### GlobalCopyScript_Example.ps

[https://gist.github.com/infamousjoeg/13fc8766304393d9f4ddd69234b0ccc7](https://gist.github.com/infamousjoeg/13fc8766304393d9f4ddd69234b0ccc7)

```powershell
# Install PoShSkyTap Module on PowerShell v5+
Install-Module PoShSkyTap

# Import PoShSkyTap Module
Import-Module PoShSkyTap

# List available commands
Get-Command -Module PoShSkyTap

# CommandType     Name                                               Version    Source
# -----------     ----                                               -------    ------
# Function        Get-TemplateStatus                                 1.0.1      poshskytap
# Function        Set-SkyTapAuth                                     1.0.1      poshskytap
# Function        Set-TemplateCopy                                   1.0.1      poshskytap
# Function        Set-TemplateName                                   1.0.1      poshskytap
# Function        Set-TemplateOwner                                  1.0.1      poshskytap
# Function        Set-TemplateProject                                1.0.1      poshskytap

# Setup SkyTap API Authentication
$authToken = Set-SkyTapAuth -Username $EmailAddressForSkyTap -APIKey $APIKeyFromSkyTap

# Start template copy process / TemplateID is the template to copy
Set-TemplateCopy -SkyTapAuth $authToken -TemplateID "123456" -TargetRegion "EMEA"

# This will return JSON output of the new Template created by the copy
# Copy the "TemplateID" as that will be the copy's ID going forward

# Change template name / TemplateID is the new template that was just created
Set-TemplateName -SkyTapAuth $authToken -TemplateID "654321" -TemplateName "EMEA CyberArk Global Demo v10_GA"

# Change template owner / OwnerID is the user ID of the new owner
Set-TemplateOwner -SkyTapAuth $authToken -TemplateID "654321" -OwnerID "1234"

# Change template project / ProjectID is the id of the project to move to
Set-TemplateProject -SkyTapAuth $authToken -TemplateID "654321" -ProjectID "56789"
```

## Technical Walkthrough

The idea is to create [gsc.ps1](gsc.ps1) as the `ENTRYPOINT` in a Microsoft SQL Server for Linux Docker container that kicks off the PowerShell script to process the automated copy.

### Docker

The Docker container uses [MSSQL-Server-Linux](https://hub.docker.com/r/microsoft/mssql-server-linux) on Ubuntu 16.04 (tagged as `:latest` or `:ubuntu16.04`) as the base image.  It installs `curl` first to add the Microsoft repositories and then installs PowerShell Core 6 (`pwsh`).

It then copies everything from this repository into the `WORKDIR` of `/etc/gsc` and sets the `ENTRYPOINT` as [gsc.ps1](gsc.ps1).

### Microsoft SQL Server

This database will hold the following data:

* Everything that is in [config.template.xml](config.template.xml) will be converted to a `.sql` file and copied with the rest of this repository.
  * This `.sql` file will be executed initially during the Docker `BUILD` to set the stage.
* It may come to be through development that this is used more than that, but it is yet to be seen.  I just like it better than an external XML file. :metal:

### gsc.ps1

* Detects/Installs/Imports [PoShSkyTap](https://www.powershellgallery.com/Packages/PoShSkyTap)
* Switches from TLS1.0 to TLS1.2
* Reads in [config.xml](config.xml)
* Creates Base64-encoded token for SkyTap API authentication

### Active Development

* Collect user input: Regions and Environments to copy to
  * Idea: Give Region/Env options on left side and add to right side as selected
* Check runstate of all VMs associated with Master Environment
  * If runstate is running, change to suspended
* Update Master Environment name to include current date
* Save Master Environment as a Template
* Add new Master Template to Master Project
* Remove old Master Template from Master Project
* Change `Settings.SkyTap.Master.TemplateID` in [config.xml](config.xml) from the old Master TemplateID to the new Master TemplateID for future copies
* Loop through Regions and Environments given by User Input
  * Begin copy of Master Template to new region
  * Update name to reflect proper region and environment
    * `{REGION}` CyberArk Global Demo v10_`{ENV}`
    * US CyberArk Global Demo v10_GA
  * Update owner to `Settings.SkyTap.Owners.{REGION}.{ENV}`
  * Add new template to `Settings.SkyTap.Projects.{REGION}.{ENV}`
* Send notification to Slack/Skype/Email/SMS once script is completed

## Desired Development

* Jenkins Pipeline with SkyTap Tag triggering advancement of pipeline
  * eg. PROD READY tagged to Master Environment
    * Last task would remove tag
* Ability to add VMs to Environment based on Conjur Demo needs
  * eg. Add CDEMO VM into environment as needed for Conjur demos
