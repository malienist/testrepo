function Build-TestLabTemplates{
	<#
	.Synopsis
    Builds the templates for TestLab. Only uses template machines from templatetypesmanifest.json
    
	.Description
    Builds the templates for TestLab. Only uses templates from templatetypesmanifest.json

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
	
	# Get a list of currently available templates and display to user.
	
	
	# Write output to pipeline
	Write-Output $output

}