function New-ISOFile{
	<#
	.Synopsis
    Provides a list of the ISOs which can be used to build template VMs.
    
	.Description
    Provides a list of ISOs from which tempalte VMs are able to be built.
    Stores:
    1. ISO File Name
    2. ISO OS Type
    3. ISO Hash
    
	.Parameter
	ISOFileName
	
	.Parameter
	ISOOS
	
	.Parameter
	ISOHash
	
	.Parameter
	ISOHashType

	.Example
	New-ISOFile -ISOFileName en_windows_server_2016_updated_feb_2018_x64_dvd_11636692.iso -ISOOS WindowsServer2016 -ISOHash 7ADC82E00F1367B43897BB969A75BBF96D46F588 -ISOHashType SHA1

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][String]$ISOFileName,
		[Parameter(Mandatory=$true)][String]$ISOOS,
		[Parameter(Mandatory=$true)][String]$ISOHash,
		[Parameter(Mandatory=$true)][string][ValidateSet('SHA1', 'SHA2', 'SHA256', 'MD5')]$ISOHashType
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		ISOFileName = $ISOFileName
		ISOOS = $ISOOS
		ISOHash = $ISOHash
		ISOHashType = $ISOHashType
	}
	
	# Tell user that ISO Manifest is being updated
	Write-Information -InformationAction Continue -MessageData "ISO Manifest being updated"

	# Create new array for list
	$isoarray = @()
	$isoarray += $output
	
	# Get the current contents of ISOManifest
	$isolist = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\ISOManifest.json | ConvertFrom-Json
	
	# Confirm ISO OS not already stored
	foreach($iso in $isolist)
	{
		if($iso.ISOOS -eq $ISOOS)
		{
			Write-Information -InformationAction Continue -MessageData "ISO Operating System already present"
		}else{
			$isoarray += $iso
		}
	}
	
	# Store back into file
	$isoarray | ConvertTo-Json | Out-File -FilePath C:\Users\HostHunter\Manifests\ISOManifest.json
	
	# Write output to pipeline
	Write-Output $output

}