function New-AnsibleServer{
	<#
	.Synopsis
    Builds up a new ansible server.
    
	.Description
    Installs ansible on an Ubuntu Server

	.Example
	New-AnsibleServer

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		VMCreated = $false
	}
	
	# Create VM, call it AnsibleServer
	$newansiblevm = New-UbuntuServer -OSName 'AnsibleServer'
	if($newansiblevm.Outcome -eq "Success")
	{
		$output.VMCreated = $true
		# Now start to configure machine
		
	}
	
	# Write output to pipeline
	Write-Output $output

}