function New-AnsibleServer{
	<#
	.Synopsis
    Builds a new ansible server.
    
	.Description
    Creates a new Ubuntu 18.04 server, then installs ansible on it. 
    Uses the Ansible Installation guide: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#installation-guide

	.Example
	New-AnsibleServer

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = @{
		Outcome = "Failed"
		VMCreated = $false
		VMCheckpoint = $false
		VMSnapshotDetails = ""
		SSHEnabled = $false
		AnsiblePublicKey = ""
	}
	
	# Create VM, call it AnsibleServer
	$newansiblevm = New-UbuntuServer -OSName 'AnsibleServer'
	if($newansiblevm.Outcome -eq "Success")
	{
		$output.VMCreated = $true
		####### Configure virtual machine to be an ansible machine ########
		# Turn machine on
		Write-Information -InformationAction Continue -MessageData "Starting AnsibleServer to begin configuration"
		Start-HyperVVM -VMName 'AnsibleServer'
		
		# Wait for reboot to finish before getting new IP
		$vmip = (Get-VM -Name 'AnsibleServer').NetworkAdapters
		if($vmip.IPAddresses -ne $null)
		{
			$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
		}else{
			while (-not $ip)
			{
				Start-Sleep -Seconds 1
				Write-Information -InformationAction Continue -MessageData "Waiting for IP Address to be established"
				$vmip = (Get-VM -Name 'AnsibleServer').NetworkAdapters
				if($vmip.IPaddresses -ne $null)
				{
					$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
				}
			}
		}
		
		
		# Turn $ip into a string
		$ip = $ip.tostring()
		$message = "AnsibleServer IP is $ip"
		Write-Information -InformationAction Continue -MessageData $message
		
		# Save the endpoint TestLab Manifest
		New-TestLabEndpoint -EPOS Ubuntu1804Server -EPPurpose Ansible -EPFileLocation 'C:\Users\HostHunter\TestLab\VirtualMachines' -EPHostName 'AnsibleServer' -EPRemoteConfigurationType 'SSH' -EPRemoteConfigurationEnabled $true -EPSMB $false -EPIPAddress $ip
		
		# With IP, setup ssh connection to server to enable installation of Ansible
		# Build command:
		$user = Read-Host "Ubuntu Server username (same as for template)"
		ssh.exe $user@$ip
		
		# Now stop VM
		Write-Information -InformationAction Continue -MessageData "Stopping AnsibleServer"
		Stop-VM -Name 'AnsibleServer' -Verbose
		
		# Take Snapshot (Microsoft calls them Checkpoints https://docs.microsoft.com/en-us/powershell/module/hyper-v/checkpoint-vm?view=win10-ps)
		Checkpoint-VM -Name AnsibleServer -SnapshotName AnsibleInstalled -Verbose
		$output.VMCheckpoint = $true
        
        # Restart VM
        Start-VM -Name AnsibleServer
        
        # Wait for 20 seconds for reboot to complete
        Start-Sleep -Seconds 20
		
		# Enable SSH on Server for future use
		$ssh = Enable-UbuntuSSH -UserName $user -IPAddress $ip
		
		if($ssh.Outcome -eq "Success")
		{
			# Take new snapshot with SSH installed
			Checkpoint-VM -Name AnsibleServer -SnapshotName SSHInstalled -Verbose

			# Get Snapshot details for future reference
			$snapshot = Get-VM -Name AnsibleServer | Get-VMSnapshot
			$output.VMSnapshotDetails = $snapshot
			
			# Get public key for Ansible Server and store in Host Hunter Framework for use configuring future Ubuntu endpoints
			Write-Information -InformationAction Continue -MessageData "Getting AnsibleServer Public Key into Host Hunter Framework"
			# Get public key
			$result = Invoke-SSHCommand -HostNameorIP $ip -Username $user -HHSystem -KeyExists True -Type Command -Command "cat ~/.ssh/id_rsa.pub"
			# Store public key in file
			$result.Outcome | Out-File -FilePath C:\Users\HostHunter\.ssh\AnsibleServerPublicKey\id_rsa.pub
			$output.AnsiblePublicKey = "C:\Users\HostHunter\.ssh\AnsibleServerPublicKey\id_rsa.pub"

			$output.Outcome = "Success"
			# Write output to pipeline
			
			Write-Output $output
		}else{
			Write-Information -InformationAction Continue -MessageData "Enabling SSH on ansible server failed. Retry"
		}
		
		# todo: record the non-standard software now installed
	}
	
	# Write output to pipeline
	Write-Output $output

}