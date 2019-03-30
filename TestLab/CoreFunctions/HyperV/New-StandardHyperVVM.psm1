function New-StandardHyperVVM{
	<#
	.Synopsis
    Creates a new Virtual Machine with Hyper V as the hypervisor
    
	.Description
    Creates a new virtual machine with Hyper V as the Virtual Machine. Settings are defined as the standard settings in the 
    HostHunter Manifest. 
    Heavy use of the below sites made:
    https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine
    https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v
    
	.Parameter
	OSType - the type of OS to be used. Parameter set is tightly controlled. 

	.Example
	New-HyperVVVM -Type Ubuntu1804Server

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10Enterprise', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType,
		[Parameter(Mandatory=$true)][string]$VMName,
		[Parameter(Mandatory=$true)][String][ValidateSet('HostHunterSwitchExternal', 'HostHunterSwitchInternal', 'HostHunterSwitchPrivate')]$Switch,
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
		
		# Use Standard Settings
		$settings = Get-StandardVMSettings -OSType $OSType
		$output.VMSettings = $settings
		$NewVMFolder = "C:\Users\HostHunter\TestLab\VirtualMachines\" + $VMName
		$NewVMPath = "C:\Users\HostHunter\TestLab\VirtualMachines\" + $VMName + "\" + $VMName + ".vhdx"
		New-VM -Name $VMName -MemoryStartupBytes $settings.RAM -Generation $settings.Generation -NewVHDPath $NewVMPath -NewVHDSizeBytes $settings.HardDriveSize -Path $NewVMFolder -SwitchName $Switch
		
	}

	# Write output to pipeline
	Write-Output $output

}