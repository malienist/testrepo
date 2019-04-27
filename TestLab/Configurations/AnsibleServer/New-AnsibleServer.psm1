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
		[Parameter(Mandatory=$true)][string]$UbuntuTemplateUsername
    )
	
	# Create custom powershell object for output
	$output = @{
		Outcome = "Failed"
		VMCreated = $false
		VMCheckpoint = $false
		VMSnapshotDetails = ""
		SSHEnabled = $false
		AnsiblePublicKey = ""
		SudoPrivilegesRemoved = $false
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
		if($vmip.IPAddresses.count -ge 2)
		{
			$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
		}else{
			while (-not $ip)
			{
				Start-Sleep -Seconds 1
				Write-Information -InformationAction Continue -MessageData "Waiting for IPv4 Address to be established"
				$vmip = (Get-VM -Name 'AnsibleServer').NetworkAdapters
				if($vmip.IPaddresses.count -ge 2)
				{
					$ip = (Get-VM -Name 'AnsibleServer').NetworkAdapters.IPAddresses[0]
				}
			}
		}
		
		
		# Turn $ip into a string
		$ip = $ip.tostring()
		$message = "AnsibleServer IP is $ip"
		Write-Information -InformationAction Continue -MessageData $message
		
		# Configure Ansible Server
		Write-Information -InformationAction Continue -MessageData "Adding software properties common"
		ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$ip "sudo apt install software-properties-common -y"
		Write-Information -InformationAction Continue -MessageData "Adding ansible apt repository"
		ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$ip "sudo apt-add-repository --yes --update ppa:ansible/ansible"
		Write-Information -InformationAction Continue -MessageData "Installing Ansible"
		ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$ip "sudo apt install ansible -y"
		
		# Save the endpoint TestLab Manifest
		New-TestLabEndpoint -EPOS Ubuntu1804Server -EPPurpose Ansible -EPFileLocation 'C:\Users\HostHunter\TestLab\VirtualMachines' -EPHostName 'AnsibleServer' -EPRemoteConfigurationType 'SSH' -EPRemoteConfigurationEnabled $true -EPSMB $false -EPIPAddress $ip
		
		# Take Snapshot (Microsoft calls them Checkpoints https://docs.microsoft.com/en-us/powershell/module/hyper-v/checkpoint-vm?view=win10-ps)
		Checkpoint-VM -Name AnsibleServer -SnapshotName AnsibleInstalled -Verbose
		$output.VMCheckpoint = $true
		
		# Create Ansible user, lower privileged
		Write-Information -InformationAction Continue -MessageData "Adding ansible user"
		ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$ip "sudo adduser --quiet --disabled-password --shell /bin/bash --home /home/ansible -gecos 'User' ansible"
		
		# Creating Ansible user SSH Key
		Write-Information -InformationAction Continue -MessageData "Creating Ansible user SSH Key"
		ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa ansible@$ip "ssh-keygen -N '' "
        
        # Get public key for Ansible Server and store in Host Hunter Framework for use configuring future Ubuntu endpoints
		Write-Information -InformationAction Continue -MessageData "Getting AnsibleServer Public Key into Host Hunter Framework"
		# Get public key
		$result = Invoke-SSHCommand -HostNameorIP $ip -Username 'ansible' -HHSystem -KeyExists True -Type Command -Command "cat ~/.ssh/id_rsa.pub"
		# Store public key in file
		$result.Outcome | Out-File -FilePath C:\Users\HostHunter\.ssh\AnsibleServerPublicKey\id_rsa.pub
		$output.AnsiblePublicKey = "C:\Users\HostHunter\.ssh\AnsibleServerPublicKey\id_rsa.pub"

		$output.Outcome = "Success"
		# Write output to pipeline
		
		# todo: record the non-standard software now installed
	}
	
	# Write output to pipeline
	Write-Output $output

}