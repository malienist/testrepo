function Build-StandardHyperVTemplate{
	<#
	.Synopsis
    Creates a HyperV Template from a virtual machine
    
	.Description
    Creates a HyperV Template from a virtual machine
    
	.Parameter
	TemplateName - the name of the template being created
	
	.Paramter
	VMName - the name of the VM being templated

	.Example
	New-HyperVTemplate -VMName Server2016_Template

	#>

	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true)][String]$VMName,
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10Enterprise', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType,
		[Parameter(Mandatory=$true)][String][ValidateSet('HostHunterSwitchExternal', 'HostHunterSwitchInternal', 'HostHunterSwitchPrivate', 'Default Switch')]$Switch
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		VMName = $VMName
		VMType = $OSType
		Created = @{}
		Started = @{}
		Config = @{}
		RemoteAccessEnabled = $false
		RemoteAccessType = ""
		SMB = $false
		IPAddress = ""
	}
	
	# First create the VM. Create linked to a disconnected switch initially
	$message = "Creating VM $VMName"
	Write-Information -InformationAction Continue -MessageData $message
	$vmcreation = New-StandardHyperVVM -OSType $OSType -VMName $VMName -Switch $Switch
	$output.Created = $vmcreation
	
	# If successful, Start VM for click through settings
	if($vmcreation.Outcome -eq "Success")
	{
		$message = "Starting VM $VMName"
		Write-Information -InformationAction Continue -MessageData $message
		$vmstart = Start-NewHyperVVM -VMName $VMName -OSType $OSType
		$output.Started = $vmstart
	}else{
		$message = "Starting VM $VMName"
		Write-Information -InformationAction Continue -MessageData $message
		$output.Started = "Failed"
	}
	
	# If VM Creation successful, wait for user to press return then continue
	if($vmstart.Outcome -eq "Success")
	{
		Read-Host "Press return when operating system installation complete"
		# Get the vm credentials
		$vmcreds = Get-Credential -Message "Input credentials (before AD creation/joining)"
		
		# Now configure Virtual Machine procedurally based upon type of Standard VM
		if($OSType -eq "WindowsServer2016")
		{
			Write-Information -InformationAction Continue -MessageData "Configuring Windows Server 2016 template"
			$vmconfig = Invoke-WindowsServer2016TemplateConfiguration -VMName $VMName -Credential $vmcreds
			$output.Config = $vmconfig
			Write-Information -InformationAction Continue -MessageData "Stopping VM to remove DVD Drive"
			Stop-VM -VMName $VMName
			# Remove DVD Drive
			Remove-VMDvdDrive -VMName $VMName -ControllerLocation 1 -ControllerNumber 0
			# Once VM modification complete, update the outcome objects to store in the TestLabEndpoint manifest
			# Update if remote access available
			$output.RemoteAccessType = "WinRM"
			$output.IPAddress = $vmconfig.IPaddress
			if($vmconfig.RemotePowershell -eq "Success")
			{
				$output.RemoteAccessEnabled = $true
			}else{
				$output.RemoteAccessEnabled = $false
			}
		}
		elseif($OSType -eq "Ubuntu1804Server")
		{
			Write-Information -InformationAction Continue -MessageData "Configuring Ubuntu Server 18.04 template"
			# Confirm with user that SSH installed
			$response = Read-Host "SSH enabled (y/n)"
			if($response -eq "y")
			{
				Write-Information -InformationAction Continue -MessageData "Testing connection"
				$output.RemoteAccessEnabled = $true
				# todo: fix this up for future updates
			}
			
			#$vmconfig = Invoke-Ubuntu1804ServerTemplateConfiguration -VMName $VMName -Credential $vmcreds
			$vmconfig = @{
				Outcome = "Success"
			}
			Write-Information -InformationAction Continue -MessageData "Stopping VM to remove DVD Drive"
			Stop-VM -VMName $VMName
			
			# Once VM modification complete, update the outcome objects to store in the TestLabEndpoint manifest
			$output.RemoteAccessType = "SSH"
			$output.IPAddress = Read-Host "IP Address from setup"
			
		}elseif($OSType -eq "Windows10Enterprise")
		{
			# Setup Windows 10 Enterprise with Powershell remoting, signed remote scripts and get IP address
			Write-Information -InformationAction Continue -MessageData "Configuring Windows 10 Enterprise template"
			$vmconfig = Invoke-Windows10EnterpriseTemplateConfiguration -VMName $VMName -Credential $vmcreds
			$output.Config = $vmconfig
			Write-Information -InformationAction Continue -MessageData "Stopping VM to remove DVD Drive"
			Stop-VM -VMName $VMName
			Remove-VMDvdDrive -VMName $VMName -ControllerLocation 1 -ControllerNumber 0
			# Once VM modification complete, update the outcome objects to store in the TestLabEndpoint manifest
			# Update if remote access available
			$output.RemoteAccessType = "WinRM"
			$output.IPAddress = $vmconfig.IPaddress
			if($vmconfig.RemotePowershell -eq "Success")
			{
				$output.RemoteAccessEnabled = $true
				$output.RemoteAccessType = 'SSH'
			}else{
				$output.RemoteAccessEnabled = $false
			}
		}
		
		# If config completed, export the VM as a template
		if($vmconfig.Outcome -eq "Success")
		{
			Write-Information -InformationAction Continue -MessageData "Exporting Virtual Machine"
			Export-VM -VMName $VMName -Path C:\Users\HostHunter\TestLab\VirtualMachines\Templates\
			$output.Outcome = "Success"
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}