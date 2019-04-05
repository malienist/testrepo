function Invoke-Ubuntu1604ServerTemplateConfiguration{
	<#
	.Synopsis
    Procedurally configures Ubuntu 1804 Server into a template configuration
    
	.Description
    Procedurally configures Ubuntu 1804 Server into a template
    
    .Parameter
    VMName - Hostname of VM
    
	.Parameter
	IP - IP address of server

	.Example
	Invoke-Ubuntu1604ServerTemplateConfiguration -IP 1.1.1.1

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$VMName,
		[Parameter(Mandatory=$true)][String]$IP
	)

	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		IPAddress = ""
		HostName = ""
	}

	# Things to put in lab setup readme
	# todo: 1. Need to grant sudo access to template user to perform specific commands at sudo without password prompting


	# Write output to pipeline
	Write-Output $output

}