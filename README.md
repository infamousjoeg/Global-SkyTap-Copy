# Global-SkyTap-Copy

### CyberArk Global Corp SE Team's Global SkyTap Copy

Automated SkyTap Master Template copy to necessary regions and environments.

Be sure to change [config.template.xml](config.template.xml) to `config.xml` and update the settings within before running the Docker container.

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