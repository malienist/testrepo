function Initialize-TestLab{
	<#
	.Synopsis
    Initializes TestLab for use integrated with HostHunter.
    
	.Description
    Sets up TestLab from scratch for use with HostHunter.

	.Example
	Initialize-TestLab

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		ISOsTransferred = "Failed"
		SSHKeys = "NotCreated"
		TemplatesBuilt = "Failed"
	}

	# Create SSH Keys for Host Hunter use
	$ssh = New-HHSSHKey -Force
	if($ssh.Outcome = "Success")
	{
		$output.SSHKeys = "Created"
	}

	# Import required ISOs into Framework
	$folder = Read-Host "Input filepath for ISO locations. Press return to use $env:USERPROFILE \Downloads\"
	if($folder)
	{
		$path = $folder
	}else{
		$path = $env:USERPROFILE + "\Downloads\"
	}
	$isolistpath = $path + "*.ISO"
	$ISOList = Get-ChildItem -Path $isolistpath

	# Notify user of the ISOs required for initial standard setup
	Write-Information -InformationAction Continue -MessageData "The initial TestLab setup requires a WindowsServer2016, Windows10Enterprise and Ubuntu1804Server ISO."
	
	while($isosavailable -ne "y")
	{
		$isosavailable = Read-Host "Confirm these ISOs are available for setup(y/n)"
	}
	
	# For each ISO in list, get OSType from User
	foreach($ISO in $ISOList)
	{
		$OSType = ""
		while($OSType -ne "WindowsServer2016" -or "Windows10Enterprise" -or "Ubuntu1804Server")
		{
			$OSType = Read-Host "Is ISO Type WindowsServer2016, Windows10Enterprise or UbuntuServer1804Server"
			$message = "OSType selected is $OSType"
			Write-Information -InformationAction Continue -MessageData $message
		}
		New-ISOForTemplate -ISOLocation $path -ISOName $ISO.Name -OSType $OSType 
	}
	
	$output.ISOsTransferred = "Success"
	
	# Now build templates from ISOs
	$buildoutcome = Build-TestLabTemplates
	if($buildoutcome.Outcome -eq "Success")
	{
		$output.TempaltesBuit = "Success"
	}
	
	# Initialize HostHunter System VMs
	Write-Information -InformationAction Continue -MessageData "Initializing HostHunter System VMs"
	New-AnsibleServer #todo: get this username programmatically
	
		# Initialize Ansible Server
	
		# Initialize SIEM Server
			# Configure SIEM Server
	
	
	# Initialize TestLab
	
	# Write output to pipeline
	Write-Output $output

}