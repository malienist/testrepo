function New-AnsibleServer{
	<#
	.Synopsis
    Sets up a new ansible server.
    
	.Description
    Installs ansible on a server then copies over a series of play books.

	.Example
	New-AnsibleServer

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	# Get IP address of Ansible server
	# todo: split this out into a module so various methods of virtualisation can be used
	
	# Write output to pipeline
	Write-Output $output

}