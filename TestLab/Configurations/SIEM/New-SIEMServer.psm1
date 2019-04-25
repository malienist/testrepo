function New-SIEMServer{
	<#
	.Synopsis
    Creates a new Ubuntu based SIEM
    
	.Description
    Creates a new Ubuntu based SIEM

	.Example
	New-SIEMServer

	#>

	[CmdletBinding()]
	param
	(

	)

	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		VMCreated = $false
		VMCheckpoint = $false
		VMCheckpointDetails = ""
	}

	# Create VM, call it SIEMServer
	$newsplunkSIEM = New-UbuntuServer -OSName 'SIEMServer'
	if($newsplunkSIEM.Outcome -eq "Success")
	{
		$output.VMCreated = $true
		# Add the keys from HHFramework and Ansible server
		# Start Server
		Write-Information -InformationAction Continue -MessageData "Starting SIEMServer to begin configuration"
		Start-HyperVVM -VMName 'SIEMServer'
		# Wait for start to finish to get new IP
		$vmip = (Get-VM -Name 'SIEMServer').NetworkAdapters
		if($vmip.IPAddresses.count -ge 2)
		{
			$ip = (Get-VM -Name 'SIEMServer').NetworkAdapters.IPAddresses[0]
		}else{
			while (-not $ip)
			{
				Start-Sleep -Seconds 1
				Write-Information -InformationAction Continue -MessageData "Waiting for IPv4 Address to be established"
				$vmip = (Get-VM -Name 'SIEMServer').NetworkAdapters
				if($vmip.IPaddresses.count -ge 2)
				{
					$ip = (Get-VM -Name 'SIEMServer').NetworkAdapters.IPAddresses[0]
				}
			}
		}
		# turn $ip into string
		$ip = $ip.tostring()
		$message = "SIEMServer IP is $ip"
		Write-Information -InformationAction Continue -MessageData $message

		# Save the endpoint to TestLab Manifest
		New-TestLabEndpoint -EPOS Ubuntu1804Server -EPPurpose SIEM -EPFileLocation 'C:\Users\HostHunter\TestLab\VirtualMachines' -EPHostName 'SIEMServer' -EPRemoteConfigurationType 'SSH' -EPRemoteConfigurationEnabled $true -EPSMB $false -EPIPAddress $ip

		# With IP, setup ssh connection to server to add HostHunter key
		Write-Information -InformationAction Continue -MessageData "Adding SSH keys for HostHunter Framework and AnsibleServer"
		$user = Read-Host "Ubuntu Server username (same as for template)"
		# todo: this can be stored in settings
		Enable-UbuntuSSH -Username $user -IPAddress $ip


		# Add UbuntuServer Key programmatically
		Write-Information -InformationAction Continue -MessageData "Adding AnsibleServer SSH key"
		cat C:\Users\HostHunter\.ssh\AnsibleServerPublicKey\id_rsa.pub | ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $user@$ip "cat >> ~/.ssh/authorized_keys"
		# todo: much error checking
		# Create Checkpoint
		$checkpoint = Checkpoint-VM -Name SIEMServer -SnapshotName SSHKeys -Verbose
		$snapshot = Get-VM -Name SIEMServer | Get-VMSnapshot
		$output.VMCheckpoint = $true
		$output.VMCheckpointDetails = $snapshot
		$output.Outcome = "Success"
		Write-Output $output
	}

	# Write output to pipeline
	Write-Output $output

}