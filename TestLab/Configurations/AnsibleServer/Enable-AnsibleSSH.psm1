function Enable-AnsibleSSH{
	<#
	.Synopsis
   Enables the use of SSH from PowerShell 6 commandline to use Ansible Server dynamically
    
	.Description
    Creates an SSH key on local host
    Stores public key locally
    Enables it to be used on Ansible server
    
    Thanks to this site: https://www.digitalocean.com/community/tutorials/how-to-set-up-ssh-keys-on-ubuntu-1604

	.Example
	Enable-AnsibleSSH

	#>

	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory=$true)][string]$Username,
	[Parameter(Mandatory=$true)][string]$IPAddress
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		SSHKeyCreated = $true
		SSHPrivateKeyStorageLocation = ""
		Outcome = "Failed"
	}
	
	# Create New HH SSH Key
	$ssh = New-HHSSHKey
	
	if($ssh.Outcome -eq "Success")
	{
		# Connect to Ansible Server and provide public key
		cat C:\Users\HostHunter\.ssh\id_rsa.pub | ssh.exe $Username@$IPAddress "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
		$output.Outcome = "Success"
	}else{
		Write-Information -InformationAction Continue -MessageData "Generation of ssh key failed. Investigate then try again"
	}
	
	
	# Write output to pipeline
	Write-Output $output

}