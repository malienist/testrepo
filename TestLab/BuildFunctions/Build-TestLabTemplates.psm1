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
	$ISOs = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\ISOManifest.json
	foreach($ISO in $ISOs)
	{
		$VMName = $ISO.ISOOS + "_Template"
		$message = "Building $VMName"
		Build-StandardHyperVTemplate -VMName $VMName -OSType $ISO.ISOOS -Switch 'Default Switch'
	}
	
	# Get a list of currently available templates and display to user.
	
	
	# Write output to pipeline
	Write-Output $output

}