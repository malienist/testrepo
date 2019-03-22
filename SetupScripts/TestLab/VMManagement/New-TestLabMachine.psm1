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
		"HostType" = ""
		"HostName" = "null"
		"IP" = "0.0.0.0"
		"WinRM" = "null"
		"Group" = "null"
		"Outcome" = "Failed"
	}

	# Depending on the type of virtualisation being used, update the required details
	if($ManualUpdate)
	{
		$output.HostType = Read-Host "HostType (AD, IIS Server, Win10Client) "
		$output.HostName = Read-Host "HostName "
		$output.IP = Read-Host "IP "
		$output.WinRM = Read-Host "WinRM Enabled? (True / False)"
		$output.Group = Read-Host "What group is vm a part of? "
	}elseif($VirtualisationPreference -eq "VMWareWorkstation"){
		
	}
	# todo: update with new types of hypervisor as they become available
	
	# Update the TestLabManifest with details
	# Get content of HostLabManifest
	$testlab = Get-Content -raw -Path $testlabmanifest | ConvertFrom-Json
	
	# Check there is no conflict in hostname or IP address
	$hostname = $testlab | Where-Object {$_.HostName -eq $output.HostName}
	$ip = $testlab | Where-Object {$_.IP -eq $output.ip}
	if($ip -ne $null -or $hostname -ne $null)
	{
		Write-Information -InformationAction Continue -MessageData "Hostname or Ip not unique. Try again" # todo: change color for this message
	}else{
		# If not, update test lab
		$testlab += @{
			HostType = $output.HostType
			HostName = $output.HostName
			IP = $output.IP
			WinRM = $output.WinRM
			Group = $output.Group
		}
		# Write to file
		$testlab | ConvertTo-Json | Out-File -FilePath $testlabmanifest
		$output.Outcome = "Success"
	}
	
	Write-Output $Output
}