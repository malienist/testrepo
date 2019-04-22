function New-SplunkSIEM{
	<#
	.Synopsis
    Provides the hostname for an IP based upon DC list
    
	.Description
    Provides the hostname for an IP based upon DC list
    
	.Parameter
	IP - The IP to be searched for

	.Example
	Get-HostNameConversion 192.168.1.23
	Gets the hostname for 192.168.1.23

	#>

	[CmdletBinding()]
	param
	(
        [string]$IP
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	# Write output to pipeline
	Write-Output $output

}