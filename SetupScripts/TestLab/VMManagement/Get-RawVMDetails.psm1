function Get-RawVMDetails{
	<#
	.Synopsis
    Gets the details of the specified virtual machine from virtual machine.
    
	.Description
    Gets the details of the specified virtual machine from virtual machine manifest
    
	.Parameter
	HostName - the host name of the details sought

	.Example
	Get-VMDetails -HostName HostHunter 

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$HostName
	)

	# Setup the powershell object to record the different fields required
	$output = @{
		"IP" = ""
		"HostOS" = ""
		"WinRM" = ""
		"Outcome" = "Failed"
	}
	
	# Get the virutalisation preference being used
	$virtualisation = Get-Content -Raw -Path $SettingsFile | ConvertFrom-Json
	$virtualisation = ($virtualisation | Where-Object {$_.Type -eq "VirtualizationType"})
	
	# Depending of the virtualization type, the way to get the raw information is going to change
	if($virtualisation -eq "VMWareWorkstation")
	{
		# Test if HostName exists in TestLab
		if((Get-VMX | Get-VMXInfo | Where-Object {$_.VMXName -eq "HostHunterClient"}).DisplayName)
		{
			# If yes, use VMXToolkit to build out details
			$output.IP = (Get-VMX |Get-VMXIPAddress | Where-Object {$_.VMXName -eq $HostName}).IPAddress
			$output.HostOS = (Get-VMX |Get-VMXGuestOS | Where-Object {$_.VMXName -eq $HostName}).GuestOS	
			# todo: Unsure how to check if WSMan has been created yet
			
		}else{
			Write-Information -InformationAction Continue -MessageData "This hostname does not exist in testlab"
		}
	}

	
	# Return the information to the user
	Write-Output $output
}