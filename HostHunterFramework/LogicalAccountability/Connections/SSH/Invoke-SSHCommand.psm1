function Invoke-SSHCommand{
	<#
	.Synopsis
    Invokes an SSH Command on a remote endpoint which is not configured to use PowerShell SSH remoting.
    
	.Description
    Invokes an SSH Command on a remote endpoint. Endpoint is not configured to use PowerShell SSH remoting. 
    This command takes care of logical accountability, whether private/public keys have been exchanged.
    
	.Parameter
	HostNameOrIP - the HostName or IP address of the hostname to be connected to
	
	.Parameter 
	Username - the username to be used for the connection
	
	.Parameter 
	HHSystem - switch to define if this endpoint is part of the HostHunter System (i.e. Ansible)
	
	.Parameter
	Type - type of command (Connection, Command, SCP)
	
	.Parameter
	KeySet - switch defining if a private/public key exchange has occured
	
	.Parameter
	Command - if Command required, the command to entered. If SCP, parameters on the SCP.

	.Example
	Invoke-SSHCommand 

	#>

	[CmdletBinding()]
	param
	(
	[Parameter(Mandatory=$true)][string[]]$HostNameorIP,
	[Parameter(Mandatory=$true)][string]$Username,
	[Parameter(Mandatory=$true)][switch]$HHSystem,
	[Parameter(Mandatory=$true)][string][ValidateSet('Connection', 'Command', 'SCP')]$Type,
	[Parameter(Mandatory=$true)][string][ValidateSet($true, $false)]$KeyExists,
	[string]$Command
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = ""
		EndPoint = $HostNameorIP
		Username = $Username
		HHSystem = $HHSystem
		ConnectionType = $Type
		KeyExists = $KeyExists
		Command = $Command
	}
	
	$idfile = 'C:\Users\HostHunter\.ssh\id_rsa'
	
	# todo: Fully configure logical accountability command
	
	if($HHSystem -or ($KeyExists -eq $true))
	{
		Write-Verbose -Message "Using Private/Public key for connection"
		# Confirm that keys exist
		$private = Test-Path -Path C:\Users\HostHunter\.ssh\id_rsa
		$public = Test-Path -Path C:\Users\HostHunter\.ssh\id_rsa.pub
		if($private -and $public -eq "True")
		{
			Write-Verbose -Message "Keys exist, continuing"
			$output.KeyExists = $true
			# If key exists, continue with command or scp
			if($output.KeyExists = $true)
			{
				foreach($host in $HostNameorIP)
				{
					if($Type -eq 'SCP')
					{
						Send-LogicalAccountability
						Write-Information -InformationAction Continue -MessageData "This will be an SCP Command in the future"
					}
					elseif ($Type -eq 'Connection')
					{
						# Set identity file to the non-standard location in the HHFramework
						Send-LogicalAccountability
						ssh.exe -i $idfile $Username@$host
						$output.Outcome = "Success"
					}
					elseif ($Type -eq 'Command')
					{
						# Set identity file to the non-standard location in the HHFramework
						Send-LogicalAccountability
						$result = ssh.exe -i $idfile $Username@$host $Command
						Send-HHDataObject -AccountabilityHash "TestHash" -DataObject $result
						$output.Outcome = "Success"
					}
				}
				
			}
		}else{
			# End here
			Write-Information -InformationAction Continue -MessageData "Keys do not exist. Create with 'New-HHSSKey' then continue"
			$output.KeyExists = $false
			$output.Outcome = "Failed"
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}