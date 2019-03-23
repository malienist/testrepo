function New-TestLab{
	<#
	.Synopsis
    Creates a new testlab.
    
	.Description
    After initial setup is complete, creates a new testlab. 
    Initial testlab is 1 x Windows Server 16, 1 x Windows 10 Client

	.Example
	New-TestLab

	#>

	[CmdletBinding()]
	param
	(
    )

	# Create custom output command for pipeline
	$output = @{
		"Outcome" = "Failed"
		"ServerStatus" = ""
		"ServerSnapshot" = ""
		"ServerWMF" = ""
		"ServerIP" = ""
		"WindowsServerTemplate" = ""
		"ServerVM" = ""
		"ClientVM" = ""
	}
	
	# Write virtualization preference to commandline
	$message = "Virtualization preference: $VirtualizationPreference"
	Write-Information -InformationAction Continue -MessageData $message
	
	# if VMwareWorkstation, check that the requested VMs exist from setup process
	if($VirtualizationPreference -eq "VMWareWorkstation")
	{
		Write-Information -InformationAction Continue -MessageData "Checking virtual machines from setup exist"
		$vms = Get-VMX 
		$server = Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"}
		$client = Get-VMX | Where-Object {$_.VMXName -eq "HostHunterClient"}
		if($server)
		{
			# Check the WSMan_Snapshot exists
			$snapshot = Get-VMX | Get-VMXSnapshot | Where-Object {$_.VMXName -eq "HostHunter"}
			$output.ServerVM = "Exists"
			if($snapshot | Where-Object{$_.Snapshot -eq "WSMan_Snapshot"})
			{
				Write-Information -InformationAction Continue -MessageData "Server snapshot confirmed"
				$output.ServerSnapshot = "WSManExists"
				# Confirm that Base VM can talk to Server using WMF (WinRM)
				# Start Virtual Machine if not already running
				if($server.State -ne "running"){
					Start-VMX -VMXName HostHunter
					output.ServerStatus = "running"
				}else{
					output.ServerStatus = "running"
				}
				# Get Server IP from raw data
				$output.ServerIP = (Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} |Get-VMXIPAddress).IPAddress
				# Now test wsman works
				if($WSMan = Test-WSMan -ComputerName $output.ServerIP)
				{
					Write-Information -InformationAction Continue -MessageData "Server WSMan confirmed"
					$output.ServerWMF = "True"
					# Now see if a template file has been created. 
					# todo: add in an option for template already exists
					
					# Create template
					# First stop VM
					Invoke-Command -ComputerName $output.ServerIP -Credential (Get-Credential) -ScriptBlock {Stop-Computer -Force}
					# Take another snapshot to ensure all settings captured. Note for a clone to work, clone must be in stopped state
					Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} | New-VMXSnapshot -SnapshotName Windows_Server_Build_Stopped
					# Turn VM into template mode
					Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} | Set-VMXTemplate
					$output.WindowsServerTemplate = "Windows_Server_Build_Stopped"
					# Set global variable for WindowsServer build template
					$global:WindowsServerTemplate = $output.WindowsServerTemplate
					Set-Setting 
					# Now create the DomainController
					Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} | New-VMXClone -BaseSnapshot WindowsServerTemplate -CloneName DomainController
					# Power on clone
					
				}else{
					Write-Information -InformationAction Continue -MessageData "Server WSMan failed. Confirm enabled"
					$output.ServerWMF = "False"
				}
			}else{
				Write-Information -InformationAction Continue -MessageData "WSMan_Snapshot does exist. Turn on and rerun command"
				$output.ServerSnapshot = "WSManFailed"
			}
		}else{
			Write-Information -InformationAction Continue -MessageData "Server VM does not exist. Please create and retry"
			$output.ServerVM = "DoesNotExist" 
		}
		if($client)
		{
			$output.ClientVM = "Exists"
		}else{
			Write-Information -InformationAction Continue -MessageData "Client VM does not exist. Please create and retry"
			$output.ServerVM = "DoesNotExist"
		}
	}
	
	
	# Write output to pipeline
	Write-Output $output
}