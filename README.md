# Global-SkyTap-Copy

### CyberArk Global Corp SE Team's Global SkyTap Copy

Automated SkyTap Master Template copy to necessary regions and environments.

[![CyberArk Ready](https://img.shields.io/badge/CyberArk-ready-blue.svg)](https://www.cyberark.com) ![Docker Automated Build](https://img.shields.io/docker/automated/nfmsjoeg/gsc.svg) 
![Docker Build Status](https://img.shields.io/docker/build/nfmsjoeg/gsc.svg)


## Pre-Requisites

Be sure to change [skytap.cred.template.xml](skytap.cred.template.xml) to `skytap.cred.xml` and update the settings within before running the Docker container.

## Current Development Status

### Initial Release

```docker
docker run --rm -it nfmsjoeg/gsc
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

### Active Development

* Send notification to Slack/Skype/Email/SMS once script is completed

## Desired Development

* Jenkins Pipeline with SkyTap Tag triggering advancement of pipeline
  * eg. PROD READY tagged to Master Environment
    * Last task would remove tag
* Ability to add VMs to Environment based on Conjur Demo needs
  * eg. Add CDEMO VM into environment as needed for Conjur demos
