function New-PullServer{
	<#
	.Synopsis
    Sets target host as a HTTP pull server for DSC.
    
	.Description
    Sets target host as a HTTP pull server for DSC.
    https://docs.microsoft.com/en-us/powershell/dsc/pull-server/pullserver
    Typically used in setup to ensure Base VM is able to create / recreate a test lab on demand.
    
	.Parameter
	Hostname - hostname to be targeted. 

	.Example
	New-PullServer -Hostname localhost

	#>

	[CmdletBinding()]
	param
	(
        $Hostname
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	# Write output to pipeline
	Write-Output $output

}