function New-HHSSHKey{
	<#
	.Synopsis
    Creates a new SSH private/public pair in the HostHunter framework for future use
    
	.Description
    Using the ssh-keygen.exe within PowerShell 6/7, creates a new private/public pair. Stores it in the HostHunter
    framework so that it's stored separately from the rest of the system.

	.Example
	New-HHSSHKey

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		SSHKeyCreated = $false
		SSHPrivateKeyStorageLocation = ""
	}
	
	# Check if key has already been created
	$private = Test-Path -Path C:\Users\HostHunter\.ssh\id_rsa
	$public = Test-Path -Path C:\Users\HostHunter\.ssh\id_rsa.pub
	
	if($private -and $public -eq "True")
	{
		Write-Information -InformationAction Continue -MessageData "Keys already exist, continue"
		$output.Outcome = "Success"
	}else{
		# Generate SSH key
		Write-Information -InformationAction Continue -MessageData "Generating SSH Key"
		ssh-keygen.exe -f C:\Users\HostHunter\.ssh\id_rsa
		$output.Outcome = "Success"
	}

	$output.SSHKeyCreated = $true
	$output.SSHPrivateKeyStorageLocation = "C:\Users\HostHunter\.ssh\id_rsa"
	
	# Write output to pipeline
	Write-Output $output

}