# Global-SkyTap-Copy

Global Corp SE Team's SkyTap Copy PowerShell script - for copying templates between regions.

Be sure to change [config.xml.template](config.xml.template) to `config.xml` and update the settings within before running `.\copy.ps1`.

## Template Copy Process Mapping

1. `Set-SkyTapAuth` to create Base64-encoded authentication token.
1. Loop through each `<Region>` in `<Regions></Regions>` within [config.xml.template](config.xml.template).
1. Loop through each `<Env>` in `<Environments></Environments>` within [config.xml.template](config.xml.template).
1. `Set-TemplateCopy` to begin copying the template right off the bat.  _If an `id` and `name` value is returned, the copy process has begun._
1. `Set-TemplateOwner` to be the User ID of the new owner.
1. `Set-TemplateName` to be the new name of the Template.  _This means changing the preceding region and preceding ` - Copy` tags._
1. `Set-TemplateProject` to be the proper region and environment Project.