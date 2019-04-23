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
	}
	
	# Generate SSH key
	Write-Information -InformationAction Continue -MessageData "Generating SSH Key"
	ssh-keygen.exe -f C:\Users\HostHunter\.ssh\id_rsa
	$output.SSHKeyCreated = $true
	$output.SSHPrivateKeyStorageLocation = C:\Users\HostHunter\.ssh\id_rsa
	
	# Connect to Ansible Server and provide public key
	cat C:\Users\HostHunter\.ssh\id_rsa.pub | ssh.exe $Username@$IPAddress "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
	
	# Write output to pipeline
	Write-Output $output

}