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
		VMCreated = $false
		VMCheckpoint = $false
		VMCheckpointDetails = ""
	}
	
	# Create VM, call it SplunkSIEM
	$newsplunkSIEM = New-UbuntuServer -OSName 'SplunkSIEM'
	if($newsplunkSIEM.Outcome -eq "Success")
	{
		$output.VMCreated = $true
		
	}
	
	
	
	# Write output to pipeline
	Write-Output $output

}