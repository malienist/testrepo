function Invoke-Ubuntu1804ServerTemplateConfiguration{
	<#
	.Synopsis
    Procedurally configures Ubuntu 1804 Server into a template configuration
    
	.Description
    Procedurally configures Ubuntu 1804 Server into a template
    
    .Parameter
    VMName - Hostname of VM
    
	.Parameter
	[string]$UbuntuTemplateIP - IP address of server
	
	.Parameter
	[string]$UbuntuTempalteUsername - Username to log into the server

	.Example
	Invoke-Ubuntu1804ServerTemplateConfiguration -IP 1.1.1.1

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$UbuntuTemplateUsername,
        [Parameter(Mandatory=$true)][String]$UbuntuTemplateIP,
		[Parameter(Mandatory=$true)][String]$VMName
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		IPAddress = $UbuntuTemplateIP
		Username = $UbuntuTemplateUsername
		HHSSHKeyCopied = $false
		LISInstalled = $false
	}
	
	Write-Information -InformationAction Continue -MessageData "Transferring HostHunter public SSH key to Ubuntu 18.04 Server"
	
	# Transfer the public SSH key to Ubuntu1804Server
	Get-Content -Path C:\Users\HostHunter\.ssh\id_rsa.pub | ssh.exe $UbuntuTemplateUsername@$UbuntuTemplateIP "mkdir -p ~/.ssh && touch ~/.ssh/authorized_keys && chmod -R go= ~/.ssh && cat >> ~/.ssh/authorized_keys"
	$output.HHSSHKeyCopied = $true
	
	# Install Microsoft Linux Integration Service (LIS)
	Write-Information -InformationAction Continue -MessageData "Setting up Linux Integration Service (LIS) on Ubuntu Template"
	Write-Information -InformationAction Continue -MessageData "Updating"
	ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$UbuntuTemplateIP "sudo apt install linux-virtual linux-cloud-tools-virtual linux-tools-virtual -y"
	ssh.exe -i C:\Users\HostHunter\.ssh\id_rsa $UbuntuTemplateUsername@$UbuntuTemplateIP "sudo update-initramfs -u"
	$output.LISInstalled = $true

	Write-Information -InformationAction Continue -MessageData "LIS setup completed successfully"
	
	$output.Outcome = "Success"
	
	# Write output to pipeline
	Write-Output $output

}