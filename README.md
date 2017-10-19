# Global-SkyTap-Copy

Global Corp SE Team's SkyTap Copy PowerShell script - for copying templates between regions

Be sure to change [config.xml.template](config.xml.template) to `config.xml` and update the settings within before running `.\copy.ps1`.

Other than that... this is a work in progress.

## Template Copy Process Mapping

For my sanity and your non-need to repeat yourself to me

1. Copy template **US CyberArk Global Demo `{{env}}`** to new region.  (For this example, `EMEA`)
2. This creates the template named **Copy of US CyberArk Global Demo
