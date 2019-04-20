function New-TestLabEndpoint{
	<#
	.Synopsis
    Updates TestLab manifest with a new endpoint. Only captures hosts used by current Host Hunter framework.
    
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
	New-TestLabEndpoint -EPOS WindowsServer2016 -EPPurpose DomainController -EPType Template -EPFileLocation <filelocation> -EPHostName TestMachine -EPRemoteConfigurationType WinRM -EPRemoteConfigurationEnabled $true -EPSMB $false -EPIPAddress 0.0.0.1	
	
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$EPOS,
		[Parameter(Mandatory=$true)][string][ValidateSet('Template', 'Target', 'Infrastructure', 'System', 'SIEM', 'Ansible', 'Client', 'Server')]$EPPurpose,
		[Parameter(Mandatory=$true)][string]$EPFileLocation,
		[Parameter(Mandatory=$true)][string]$EPHostName,
		[Parameter(Mandatory=$true)][string][ValidateSet('SSH', 'WinRM')]$EPRemoteConfigurationType,
		[Parameter(Mandatory=$true)][string][ValidateSet($true, $false)]$EPRemoteConfigurationEnabled,
		[Parameter(Mandatory=$true)][string][ValidateSet($true, $false)]$EPSMB,
		[Parameter(Mandatory=$true)][string]$EPIPAddress
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
	}
	
	New-TestLabManifestItem -ItemOS $EPOS -ItemPurpose $EPPurpose -ItemFileLocation $EPFileLocation -ItemName $EPHostName -ItemRemoteConfigurationType $EPRemoteConfigurationType -ItemRemoteConfigurationEnabled $EPRemoteConfigurationEnabled -ItemSMB $EPSMB -ItemIPAddress $EPIPAddress
	
	# Write output to pipeline
	Write-Output $output

}