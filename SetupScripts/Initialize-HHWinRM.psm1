function Initialize-HHWinRM{
	<#
	.Synopsis
    Ensures HostHunter machine WinRM is enabled and working.
    
	.Description
    Ensures HostHunter WinRM is enabled and working. Changes the network connection state if required. 

	.Example
	Initialize-HHWinRM

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		NetworkConnectionState = ""
		WinRMEnabled = ""
	}

	Write-Information -InformationAction Continue -MessageData "Ensuring Powershell Remoting works"
	
	# Ensure Network Connection not set to Public
	$outcome = "n"
	$output.NetworkConnectionState = "Public"
	while($outcome -ne "y")
	{
		# Display a list of network connections to the user. Do this as this will change depending on if virtual machines, templates etc used
		Write-Information -InformationAction Continue -MessageData "Getting Network Connection profile"
		Get-NetConnectionProfile
		$outcome = Read-Host "Confirm required network connection not Public. If 'n' selected, a list of instructions will be provided. Network profile will most likely be similar to 'InterfaceAlias: Ethernet x' (y/n)"
		if($outcome -ne "y")
		{
			# Request the interface index from user
			$interfaceindex = Read-Host "Input the InterfaceIndex to make Private"
			Write-Information -InformationAction Continue -MessageData "Setting selected InterfaceIndex to Private"
			# Set selected interface index to Private
			Set-NetConnectionProfile -InterfaceIndex $interfaceindex -NetworkCategory Private -Verbose
		}
	}
	
	# Update outcome with the good news
	if($outcome -eq "y")
	{
		$output.NetworkConnectionState = "NotPublic"
	}
	
	# Enable Remoting and setup trusted hosts
	if($output.NetworkConnectionState -eq "NotPublic")
	{
		Write-Information -InformationAction Continue -MessageData "Enabling PSRemoting"
		Enable-PSRemoting -Force
		Set-Item WSMan:localhost\client\TrustedHosts *
		$output.WinRMEnabled = $true
		$output.Outcome = "Success"
	}
	
	# Write output to pipeline
	Write-Output $output

}