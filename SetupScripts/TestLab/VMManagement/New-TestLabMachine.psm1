function New-TestLabMachine{
	<#
	.Synopsis
    Creates a new test lab virutal machine and stores details into testlabmanifest.json. If virtualisation software
    is not being used which does not enable powershell creation of a new virutal machine, user needs to input 
    details manually.
    
	.Description
    Creates a new test lab virtual machine and stores details into testlabmanifest.json. 
    Settings file contains the type of virtualisation software being used, this determines the parameters which
    need to be used. 
    If virtualisation software being used does not enable automated creation of virutal machines, user is required
    to input details manually
    
	.Parameter
	$ManualUpdate - used for initial entry of values for test lab

	.Example
	New-TestLabMachine

	#>

	[CmdletBinding()]
	param
	(
        [switch]$ManualUpdate
    )
	
	$output = @{
		HostType = ""
		HostName = ""
		$IP = ""
		$WinRM = ""
		$Outcome = "Failed"
	}
	
	# Get the type of virtualisation being used
	$Virtualisation = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\settings.json |ConvertFrom-Json
	$Virtualisation = ($Virtualisation | Where-Object {$_.Type -eq "VirtualizationType"}).Vendor

	# Depending on the type of virtualisation being used, update the required details
	if($Virtualisation -eq "VMware" -or $ManualUpdate)
	{
		$output.HostType = Read-Host "HostType (AD, IIS Server, Win10Client): "
		$output.HostName = Read-Host "HostName: "
		$output.IP = Read-Host "IP: "
		$output.WinRM = Read-Host "WinRM Enabled? "
	}
	# todo: update with new types of hypervisor as they become available
	
	# Update the TestLabManifest with details
	# Get content of HostLabManifest
	
	
}