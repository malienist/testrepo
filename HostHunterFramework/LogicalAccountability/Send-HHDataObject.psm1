function Send-HHDataObject{
	<#
	.Synopsis
    Sends a HostHunter Data Object to SIEM
    
	.Description
    Sends a HostHunter Data Object to SIEM
    
	.Parameter
	AccountabilityHash
	
	.Parameter
	DataObject

	.Example
	Send-HHDataObject -AccountabilityHash $Hash -DataObject $result

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$AccountabilityHash,
		[Parameter(Mandatory=$true)]$DataObject
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	Write-Information -InformationAction Continue -MessageData "One day this will be the logical accountability object"
	
	# Write output to pipeline
	Write-Output $output

}