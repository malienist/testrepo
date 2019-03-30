function New-StandardHyperVVM{
	<#
	.Synopsis
    Creates a new Virtual Machine with Hyper V as the hypervisor
    
	.Description
    Creates a new virtual machine with Hyper V as the Virtual Machine
    
	.Parameter
	OSType - the type of OS to be used. Parameter set is tightly controlled. 

	.Example
	New-HyperVVVM -Type Ubuntu1804Server

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType,
		[Parameter(Mandatory=$true)][string]$VMName,
		[Parameter][switch]$NonStandardSettings
	)

	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		VMType = $OSType
		ISOExists = "False"
		VMPath = ""
		VMSettings = @{}
		VMName = $VMName
	}

	# Set base path. Deliberately abstracted from reload script as all interaction with ISOs should be through the commandlets
	$path = "C:\Users\HostHunter\TestLab\ISOs\"

	# Check the correct iso exists
	# todo: make this more generic as versions will change
	if($OSType -eq 'WindowsServer16')
	{
		$path = $path + "en_windows_server_2016_updated_feb_2018_x64_dvd_11636692.iso"
		$file = Test-Path -Path $path
		if($file)
		{
			Write-Verbose "Windows Server 2016 exists"
			$output.ISOExists = "True"
			$output.VMPath = $path
		}else{
			Write-Information "Windows Server 2016 does not exist. Download file and try again"
			$output.ISOExists = "False"
		}
	}
	elseif ($OSType -eq 'Windows10')
	{
		$path = $path + "en_windows_10_enterprise_version_1703_updated_march_2017_x64_dvd_10189290.iso"
		$file = Test-Path -Path $path
		if($file)
		{
			Write-Verbose "Windows 10 Enterprise exists"
			$output.ISOExists = "True"
			$output.VMPath = $path
		}else{
			Write-Information "Windows 10 Enterprise does not exist. Download file and try again"
			$output.ISOExists = "False"
		}
	}
	elseif ($OSType -eq 'Ubuntu1804Server')
	{
		$path = $path + "ubuntu-18.04.2-live-server-amd64.iso"
		$file = Test-Path -Path $path
		if($file)
		{
			Write-Verbose "Ubuntu 18.04 Server exists"
			$output.ISOExists = "True"
			$output.VMPath = $path
		}else{
			Write-Information "Ubuntu 18.04 Server does not exist. Download file and try again"
			$output.ISOExists = "False"
		}
	}elseif ($OSType -eq 'Ubuntu1804Client')
	{
		$path = $path + "ubuntu-18.04.2-desktop-amd64.iso"
		$file = Test-Path -Path $path
		if($file)
		{
			Write-Verbose "Ubuntu 18.04 Desktop exists"
			$output.ISOExists = "True"
			$output.VMPath = $path
		}else{
			Write-Information "Ubuntu 18.04 Desktop does not exist. Download file and try again"
			$output.ISOExists = "False"
		}
	}

	# If path exists create VM
	if($output.ISOExists -eq "True")
	{
		if(-not $NonStandardSettings)
		{
			# Use Standard Settings
			$settings = Get-StandardVMSettings -OSType $OSType
			$output.VMSettings = $settings
			New-VM -Name $VMName -
		}else{
			# Get new settings fo standard ISO 
			$RAM = Read-Host "RAM Size in GB (e.g. 2GB)"
			$Generation = Read-Host "Generation (1 or 2)"
			$HardDrive = Read-Host "Hard Drive size in GB (e.g. 20GB)"
			$settings = @{
				RAM = $RAM
				HardDriveSize = $HardDrive
				Generation = $Generation
			}
			$output.VMSettings = $settings
		}
	}

	# Write output to pipeline
	Write-Output $output

}