function Start-HyperVVM{
	<#
	.Synopsis
    Starts a HyperV VM then opens for configuration to occur
    
	.Description
    Starts a HyperV VM then opens for configuation to occur.
    
	.Parameter
	VMName - the name of the VM to connect to

	.Example
	Start-HyperVVM -VMName HostHunterServer

	#>

	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true)][string]$VMName,
		[switch]$initial
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		Initial = "False"
	}
	
	if($initial)
	{
		output.Initial = "True"
		
		# Connect up DVD with ISO 
		
	}
	
	Start-VM -Name $VMName
	
	
	# Write output to pipeline
	Write-Output $output

}