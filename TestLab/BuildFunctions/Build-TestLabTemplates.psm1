function Build-TestLabTemplates{
	<#
	.Synopsis
    Builds the templates for TestLab. Only uses template machines from templatetypesmanifest.json
    
	.Description
    Builds the templates for TestLab. Only uses templates from the ISOs in ISOManifest.json

	.Example
	Build-TestLabTemplates

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	# Get a list of the current standard ISOs
	Write-Information -InformationAction Continue -MessageData "#######################################################"
	Write-Information -InformationAction Continue -MessageData "Building TestLab Templates"
	Write-Information -InformationAction Continue -MessageData "#######################################################"
	
	# Build the HostHunter Switch
	Write-Information -InformationAction Continue -MessageData "Creating Host Hunter switch"
	Get-NetAdapter
	$switchname = New-HostHunterSwitch -SwitchType Internal | Out-Null
	
	# Get the new Switch 
	$switchname = "HostHunterSwitchInternal"

	Write-Information -InformationAction Continue -MessageData "#######################################################"
	
	$ISOs = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\ISOManifest.json | ConvertFrom-Json
	foreach($ISO in $ISOs)
	{
		$VMName = $ISO.ISOOS + "_Template"
		$ISOName = $ISO.ISOOS
		$message = "Building $VMName"
		Write-Information -InformationAction Continue -MessageData $message
		if($VirtualizationType -eq 'HyperV')
		{
			Build-StandardHyperVTemplate -VMName $VMName -OSType $ISOName -Switch 'Default Switch'
			Write-Information -InformationAction Continue -MessageData "#######################################################"
		}
		
	}
	
	# Get a list of currently available templates and display to user.
	
	
	# Write output to pipeline
	Write-Output $output

}