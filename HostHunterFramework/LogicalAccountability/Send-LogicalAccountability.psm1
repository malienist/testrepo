function Send-LogicalAccountability{
	<#
	.Synopsis
    Sends a logical accountability object to SIEM
    
	.Description
    Sends a logical accountability object to SIEM

	.Example
	Send-LogicalAccountability

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	Write-Information -InformationAction Continue -MessageData "This will become a logical accountability object soon"
	
	# Write output to pipeline
	Write-Output $output

}