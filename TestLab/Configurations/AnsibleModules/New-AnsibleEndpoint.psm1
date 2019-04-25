function New-AnsibleEndpoint{
	<#
	.Synopsis
    Adds a new ansible endpoint to ansible hosts file for TestLab. 
    
	.Description
    Adds a new ansible endpoint to ansible hosts file then confirms it is working. 
    Makes extensive use of https://docs.ansible.com/ansible/latest/user_guide/intro_getting_started.html
    
	.Parameter
	HostName

	.Example
	New-AnsibleEndpoint -HostName SIEMServer

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$HostName
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		HostExists = $false
		HostAddedtoFile = $false
	}
	
	# Add Host IP to Ansible hosts file
	$testlab = Get-Content -Raw -Path $TestLabManifest | ConvertFrom-Json
	
	# Get IP Address for the HostName selected
	$newhostip = ($testlab | Where-Object {$_.ItemName -eq $HostName}).ItemIPAddress
	if($newhostip -eq $null)
	{
		$message = "$HostName does not exist in TestLab Manifest. Try again."
		Write-Information -InformationAction Continue -MessageData $message
	}else{
		$output.HostExists = $true
	}
	
	# Now add IP address to ansible hosts file
	$commandstring = "echo '$newhostip' >> /etc/ansible/hosts"
	$commandscriptblock = [ScriptBlock]::Create($commandstring)
	Write-Host $commandstring
	Invoke-HostCommand -HostName AnsibleServer -Command $commandscriptblock
	$output.HostAddedtoFile = $true
	
	# Test that IP Address for file can be returned by Ansible ping
	
	
	# Write output to pipeline
	Write-Output $output

}