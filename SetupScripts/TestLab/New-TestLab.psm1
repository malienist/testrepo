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
				$output.ServerIP = (Get-VMX | Get-VMXIPAddress | Where-Object {$_.VMXName -eq "HostHunter"} ).IPAddress
				# Now test wsman works
				if($WSMan = Test-WSMan -ComputerName $output.ServerIP)
				{
					Write-Information -InformationAction Continue -MessageData "Server WSMan confirmed"
					$output.ServerWMF = "True"
				}else{
					Write-Information -InformationAction Continue -MessageData "Server WSMan failed. Confirm enabled"
					$output.ServerWMF = "False"
				}
			}else{
				Write-Information -InformationAction Continue -MessageData "WSMan_Snapshot does exist. Turn on and rerun command"
				$output.ServerSnapshot = "WSManFailed"
			}
		}
	}
	
	
	# Write output to pipeline
	Write-Output $output
}