function Edit-StandardVMSettings{
	<#
	.Synopsis
    Enables editing of standard VM Settings
    
	.Description
    Enables editing of standard VMSettings
    
	.Parameter
	OSType - the OSType to be edited 

	.Example
	Edit-StandardVMSettings -OSType WindowsServer2016

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10Enterprise', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType
    )
	
	# Standard VM Settings location
	$settingspath = "C:\Users\HostHunter\Manifests\standardvmsettings.json"
	
	# Get Standard VM Settings
	$standardvmmanifest = Get-Content -Raw -Path $settingspath | ConvertFrom-Json
	
	# Select the VM to be modified 
	$modifiablevm = $standardvmmanifest | Where-Object {$_.OSType -eq $OSType}
	
	# Run through the settings to be edited
	# RAM
	$Message = "Current RAM for $OSType = $modifiablevm.RAM"
	Write-Information -InformationAction Continue -MessageData $Message
	$RAM = Read-Host "New RAM setting (press return if not changed)"
	if($RAM)
	{
		($standardvmmanifest | Where-Object {$_.OSType -eq $OSType}).RAM = $RAM 
	}
	# HardDriveSpace
	$Message = "Current Hard Drive Size for $OSType = $modifiablevm.HardDriveSize"
	Write-Information -InformationAction Continue -MessageData $Message
	$HardDriveSize = Read-Host "New Hard Drive Size setting (press return if not changed)"
	if($HardDriveSize)
	{
		($standardvmmanifest | Where-Object {$_.OSType -eq $OSType}).HardDriveSize= $HardDriveSize
	}
	# VM Generation
	$Message = "Current VM Generation for $OSType = $modifiablevm.Generation"
	Write-Information -InformationAction Continue -MessageData $Message
	$RAM = Read-Host "New Generation setting (press return if not changed)"
	if($RAM)
	{
		($standardvmmanifest | Where-Object {$_.OSType -eq $OSType}).Generation = $Generation
	}
	
	# Now save manifest back to manifest file
	$standardvmmanifest | ConvertTo-Json | Out-File -FilePath $settingspath
	
	# Get new settings 
	$newsettings = Get-Content -Raw -Path $settingspath | ConvertFrom-Json
	
	# Provide user new settings
	$output = $newsettings | Where-Object {$_.OSType -eq $OSType}
	
	# Write output to pipeline
	Write-Output $output

}