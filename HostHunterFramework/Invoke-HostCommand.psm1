function Invoke-HostCommand{
	<#
	.Synopsis
    Primary module for Host Hunter Framework. Provides the basis for all interaction with remote machines
    
	.Description
    Primary module for Host Hunter Framework interaction. All interaction with remote machines coordinated through this command
    
	.Parameter
	HostName - HostName of endpoint(s) to interact with
	
	.Parameter
	System - switch for using system. Uses default method for each endpoint.
	
	.Parameter
	EscalationType - when a different system escalation method desired. 

	.Example
	Invoke-HostCommand -HostName AnsibleServer -Command "ps"
	Runs a command using ssh.exe on AnsibleServer endpoint
	
	Invoke-HostCommand -HostName Win10_Target -System
	Runs a command on Win10_Target endpoint using WinRM, escalating to system using TokenImpersonation method

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string[]]$HostName,
		[Parameter(Mandatory=$true)][ScriptBlock]$Command,
		$params,
		[switch]$System,
		[string][ValidateSet('TokenImpersonation', 'NamedPipe')]$EscalationType
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		
	}
	
	# Format list of HostNames into useable items
	# If item is part of HostHunter System, use IP Address
	$HostNameList
	# Get TestLab Manifest
	$testlab = Get-Content -Raw -Path $TestLabManifest | ConvertFrom-Json
	
	foreach($endpoint in $HostName)
	{
		# Check if host in TestLab as part of the HostHunter System
		if($testlab | Where-Object {$_.ItemName -eq $endpoint} | Where-Object {$_.ItemPurpose -eq 'Ansible' -or 'SIEM'})
		{
			# Use IP Address
			$newhost = $testlab | Where-Object {$_.ItemName -eq $endpoint}
			# If using ssh.exe, endpoints will need to be queried individually
			if($newhost.ItemRemoteConfigurationType -eq 'SSH')
			{
				$message = "Individual configuration required for $endpoint"
				Write-Information -InformationAction Continue -MessageData $message
				# If no params, use default Command setting
				if(-not $params)
				{
					Write-Verbose -Message "No params selected, using default command setting"
					# Convert scriptblock to string
					$commandstring = $command.ToString()
					$sshoutcome = Invoke-SSHCommand -HostNameorIP $newhost.ItemIPAddress -UserName $username -HHSystem -Type Command -KeyExists True -Command $commandstring
				}
				
			}
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}