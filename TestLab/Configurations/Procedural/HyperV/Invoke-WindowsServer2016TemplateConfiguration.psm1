function Invoke-WindowsServer2016TemplateConfiguration{
	<#
	.Synopsis
    Configures a Windows Server 2016 machine into the basic config to template. Only useful for initial setup
    
	.Description
    Configures a Windows Server 2016 machine into the basic config to template. Only useful for initial setup
    
	.Parameter
	VMName - the name of the VM being templated

	.Example
	New-WindowsServer2016Configuration -VMName Server2016

	#>

	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true)][string]$VMName,
		[Parameter(Mandatory=$true)][System.Management.Automation.CredentialAttribute()]$Credential
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		RemoteSigned = ""
		IPAddress = ""
		RemotePowershell = ""
		HostName = ""
	}
	
	# Ensure locally unsigned scripts can run
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Set-ExecutionPolicy -ExecutionPolicy RemoteSigned}
	$executionpolicy = Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Get-ExecutionPolicy}
	if($executionpolicy.Value -eq "RemoteSigned")
	{
		Write-Information -InformationAction Continue -MessageData "Execution Policy set to Remote Signed"
		$output.RemoteSigned = "True"
	}
	
	# Change network adapter to get an ip address
	Connect-VMNetworkAdapter -VMName $VMName -SwitchName 'Default Switch' # todo: make this a much cooler switch name
	
	# Ensure powershell remoting enabled
	# Enable PSRemoting
	Write-Information -InformationAction Continue -MessageData "Enabling Remote Powershell"
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Enable-PSRemoting -Force}
	# Set trusted hosts to * - note not recommended, however this will be changed once the configuration sets in.
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Set-Item WSMan:\localhost\Client\TrustedHosts *}
	# Enable winrm
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{winrm quickconfig}
	# Test WinRM works
	# Get IP address
	$ipaddress = Invoke-Command -VMName Server2016_Template -Credential $Credential -ScriptBlock{Get-NetIPAddress | Select-Object IPAddress, InterfaceAlias, AddressFamily | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -eq "Ethernet"}}
	$output.IPAddress = [String]$ipaddress.IPAddress
	# Use Invoke-Command with IP to get Computername
	$computername = Invoke-Command -ComputerName $output.IPAddress -Credential $Credential -ScriptBlock{$env:COMPUTERNAME}
	if($computername)
	{
		# Invoke command was a success
		$output.RemotePowershell = "Success"
		$output.HostName = $computername
		$output.Outcome = "Success"
	}
	
	# Write output to pipeline
	Write-Output $output

}