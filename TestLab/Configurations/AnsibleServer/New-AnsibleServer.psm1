function New-AnsibleServer{
	<#
	.Synopsis
    Builds up a new ansible server.
    
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
		$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
		
		while (-not $ip)
		{
			Start-Sleep -Seconds 1
			Write-Information -InformationAction Continue -MessageData "Waiting for IP Address to be established"
			$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
			# todo: somehow programmatically check this
		}
		# Turn $ip into a string
		$ip = $ip.tostring()
		$message = "AnsibleServer IP is $ip"
		Write-Information -InformationAction Continue -MessageData $message
		
		# Save the completed details to TestLab Manifest
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
		Enable-AnsibleSSH -UserName $user -IPAddress $ip
		
		# Take new snapshot with SSH installed
		Checkpoint-VM -Name AnsibleServer -SnapshotName SSHInstalled -Verbose

		# Get Snapshot details for future reference
		$snapshot = Get-VM -Name AnsibleServer | Get-VMSnapshot
		$output.VMSnapshotDetails = $snapshot
		
		$output.Outcome = "Success"
		# todo: record the snapshot being taken for future reference
		
		
		# todo: record the non-standard software now installed
	}
	
	# Write output to pipeline
	Write-Output $output

}