function New-SplunkSIEM{
	<#
	.Synopsis
    Creates a Splunk based SIEM
    
	.Description
    Creates an Ubuntu Virtual Machine, then installs and configures Splunk using ansible

	.Example
	New-SplunkSIEM

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
	}
	
	# Create the SIEMServer
	$SIEM = New-SIEMServer
	
	# Write output to pipeline
	Write-Output $output

}