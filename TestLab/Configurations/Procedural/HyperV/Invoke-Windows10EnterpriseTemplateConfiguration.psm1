function Invoke-Windows10EnterpriseTemplateConfiguration{
	<#
	.Synopsis
    Configures a Windows 10 Enterprise machine into the basic configuration for a template. Only useful for initial
    setup
    
	.Description
    Configures a Windows 10 Enterprise machine into the basic configuration for a template. Only useful for initial
    setup
    
	.Parameter
	VMName - the name of the Virtual Machine being templated
	
	.Parameter
	Credential - local credentials to the Windows 10 Enterprise machine being templated

	.Example
	Invoke-Windows10EnterpriseTemplateConfiguration -VMName Win10Ent_Template -Credential $cred

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
		VMSwitch = ""
		NetConnectionProfile = ""
	}
	
	# Ensure locally unsigned scripts can run
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Set-ExecutionPolicy -ExecutionPolicy RemoteSigned}
	
	# Confirm change has been accepted
	$executionpolicy = Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Get-ExecutionPolicy}
	if($executionpolicy.Value -eq "RemoteSigned")
	{
		Write-Information -InformationAction Continue -MessageData "Execution Policy set to Remote Signed"
		$output.RemoteSigned = "True"
	}
	
	# Set network connection profile to Private for setup purposes
	# Get current network connection profile
	$connectionprofile = Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Get-NetConnectionProfile}
	if($connectionprofile.NetworkCategory -eq "Public" -or $connectionprofile.NetworkCategory -eq 0)
	{
		Write-Information -InformationAction Continue -MessageData "Network Connection profile set to 'Public'. Changing to 'Private'"
		# Set connection to private
		Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Set-NetConnectionProfile -InterfaceAlias 'Ethernet' -NetworkCategory 'Private'}
		# Confirm change has occured
		$connectionprofile = Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Get-NetConnectionProfile}
		if($connectionprofile.NetworkCategory -eq "Private")
		{
			Write-Information -InformationAction Continue -MessageData "Network Connection state changed to 'Private'"
			$output.NetConnectionProfile = "Private"
		}else{
			Write-Information -InformationAction Continue -MessageData "Unable to fix, try manually"
		}
	}
	
	# Ensure network adapter is 'Default Switch' so that it can connect to other machines :todo: connect a different switch
	$switch = (Get-VMNetworkAdapter -VMName $VMName).SwitchName
	if($switch -ne 'Default Switch')
	{
		Connect-VMNetworkAdapter -VMName $VMName -SwitchName 'Default Switch'
		$output.VMSwitch = $switch
	}else{
		$output.VMSwitch = $switch
	}

	# Ensure powershell remoting enabled
	# Enable PSRemoting
	Write-Information -InformationAction Continue -MessageData "Enabling Remote Powershell"
	# todo: error handling if incorrect username / password combination
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Enable-PSRemoting -Force}
	# Set trusted hosts to * - note not recommended, however this will be changed once the configuration sets in.
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Set-Item WSMan:\localhost\Client\TrustedHosts *}
	# Enable winrm
	Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{winrm quickconfig}
	# Test WinRM works
	# Wait for 10 seconds while WinRM completes restart
	# Write-Information -InformationAction Continue -MessageData "Waiting 10 seconds for WinRM restart"
	# Start-Sleep -Seconds 10
	# Get IP address
	$ipaddress = Invoke-Command -VMName $VMName -Credential $Credential -ScriptBlock{Get-NetIPAddress | Select-Object IPAddress, InterfaceAlias, AddressFamily | Where-Object {$_.AddressFamily -eq 'IPv4' -and $_.InterfaceAlias -eq "Ethernet"}}
	$output.IPAddress = [String]$ipaddress.IPAddress
	# Use Invoke-Command with IP to get Computername
	$computername = Invoke-Command -ComputerName $output.IPAddress -Credential $Credential -ScriptBlock{$env:COMPUTERNAME}

	# Confirm the WinRM components are all working
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