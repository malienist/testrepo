function Set-Setting{
	<#
	.Synopsis
    Updates a setting in the settings manifest.
    
	.Description
    Updates a setting in the settings manifest
    
	.Parameter
	Type - The setting being updated. Mandatory.
	
	.Parameter
	FileLocation - Location of file / resource
	
	.Parameter
	Vendor - Vendor required
	
	.Parameter
	Version - Version of product

	.Example
	Set-Setting -Type VirtualizationType -Version 14 -Vendor VMWareWorkstation

	#>

	[CmdletBinding()]
	param
	(
	[parameter(Mandatory=$true)]$Type,
	$Version,
	$Vendor,
	$FileLocation,
	$Setting
    )
	
	$output = @{
		"Outcome" = "Failed"
	}
	
	# Get the settings file
	$settings = Get-Content -Raw -Path $settingsfile | ConvertFrom-Json
	
	#Update the setting with the advised information
	#Update version
	$settings = ($settings | Where-Object {$_.Type -eq $Type}).Version = $Version
	$settings = ($settings | Where-Object {$_.Type -eq $Type}).Vendor = $Vendor
	$settings = ($settings | Where-Object {$_.Type -eq $Type}).FileLocation = $FileLocation
	
	# Write back to file
	$settings | ConvertTo-Json | Out-File -FilePath $settingsfile
	
	$output.Outcome = "Success"
	
	Write-Output $outcome
}