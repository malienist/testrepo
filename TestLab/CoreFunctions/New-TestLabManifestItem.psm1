function New-TestLabManifestItem{
	<#
	.Synopsis
    Updates TestLab manifest with a new TestLab Item. Only captures items used by current Host Hunter framework.
    
	.Description
    Updates TestLab manifest with a new endpoint. Captures hosts in use by current framework.
    Key information it captures:
    1. Operating System of Endpoint
    2. Endpoint Purpose (i.e. AD)
    3. EndpointType (Template, In Use)
    4. File Location of Endpoint
    5. Hostname - name of host
    6. RemoteConfiguration access - SSH / WinRM
    7. RemoteConfigurationEnabled - true or false
    8. SMBEnabled - default setting of SMB comms
    9. IPAddress
    
	.Parameter
	EPOS - the type of Operating System the endpoint is using
	
	.Parameter
	EPPurpose - Purpose of the end point
	
	.Parameter
	EPType - the type of endpoint (template or TestLab)
	
	.Parameter
	EPFileLocation - File location of Virtual Machine. Especially relevant for templates
	
	.Parameter
	EPHostname - Host name of endpoint
	
	.Parameter
	EPRemoteConfigurationType - Either SSH or WinRM at this stage
	
	.Parameter
	EPRemoteConfigurationEnabled - true or false
	
	.Parameter
	EPSMB - default setting of SMB communications being enabled - true or false
	
	.Parameter
	IPAddress - the IP Address of endpoint

	.Example
	New-TestLabManifestItem -EPOS WindowsServer2016 -EPPurpose DomainController -EPType Template -EPFileLocation <filelocation> -EPHostName TestMachine -EPRemoteConfigurationType WinRM -EPRemoteConfigurationEnabled $true -EPSMB $false -EPIPAddress 0.0.0.1	
	
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$ItemOS,
		[Parameter(Mandatory=$true)][string][ValidateSet('Template', 'Target', 'Infrastructure', 'Ansible', 'Switch', 'AD', 'SIEM', 'Client')]$ItemPurpose,
		[Parameter(Mandatory=$true)][string]$ItemFileLocation,
		[Parameter(Mandatory=$true)][string]$ItemName,
		[Parameter(Mandatory=$true)][string][ValidateSet('SSH', 'WinRM', 'NA', 'HyperV')]$ItemRemoteConfigurationType,
		[Parameter(Mandatory=$true)][string][ValidateSet($true, $false)]$ItemRemoteConfigurationEnabled,
		[Parameter(Mandatory=$true)][string][ValidateSet($true, $false, 'NA')]$ItemSMB,
		[Parameter(Mandatory=$true)][string]$ItemIPAddress
	)

	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
	}
	
	# Get the TestLab Manifest
	$TestLabList = Get-Content -Raw -Path $TestLabManifest | ConvertFrom-Json
	
	# Setup TestLab Array
	$TestLabArray = @()
	
	# Check item is not already in manifest
	if($TestLabList | Where-Object {$_.HostName -eq $ItemName} )
	{
		$message = $ItemName + " already in manifest"
		$output.Outcome = "ItemNotRequired"
		Write-Information -InformationAction Continue -MessageData $message
	}
	else
	{
		# Add all items to TestLab array 
		$newitem = @{
			ItemOS = $ItemOS
			ItemPurpose = $ItemPurpose
			ItemFileLocation = $ItemFileLocation
			ItemName = $ItemName
			ItemRemoteConfigurationType = $ItemRemoteConfigurationType
			ItemRemoteConfigurationEnabled = $ItemRemoteConfigurationEnabled
			ItemSMB = $ItemSMB
			ItemIPAddress = $ItemSMB
		}
		$TestLabArray += $newitem
		$output.Outcome = "Success"
		foreach($item in $TestLabList)
		{
			$TestLabArray += $item
		}
		# Write back to file
		$TestLabArray | ConvertTo-Json | Out-File -FilePath $TestLabManifest
		# Inform user
		$message = $ItemName + " added to TestLab manifest"
		Write-Information -InformationAction Continue -MessageData $message
	}

	# Write output to pipeline
	Write-Output $output

}