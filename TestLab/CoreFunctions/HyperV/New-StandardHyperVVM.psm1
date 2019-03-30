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
		VMPath = ""
		VMSettings = @{}
		VMName = $VMName
	}

	# Use Standard Settings
	$settings = Get-StandardVMSettings -OSType $OSType
	$output.VMSettings = $settings
	
	# Need to convert the RAM size string into int64 again
	$RAMstr = $settings.RAM
	$RAM = [int64]$RAMstr.Replace('GB','') * 1GB
	
	# Need to convert the Hard Drive size string into into64 again
	$VHDstr = $settings.HardDriveSize
	$VHD = [int64]$VHDstr.Replace('GB','') * 1GB
	$NewVMFolder = "C:\Users\HostHunter\TestLab\VirtualMachines\" + $VMName
	$NewVMPath = "C:\Users\HostHunter\TestLab\VirtualMachines\" + $VMName + "\" + $VMName + ".vhdx"
	$output.VMPath = $NewVMPath
	$vm = New-VM -Name $VMName -MemoryStartupBytes $RAM -Generation $settings.Generation -NewVHDPath $NewVMPath -NewVHDSizeBytes $VHD -Path $NewVMFolder -SwitchName $Switch
	if($vm.Name -eq $VMName -and $vm.Status -eq "Operating normally")
	{
		$output.Outcome = "Success"
	}
	

	# Write output to pipeline
	Write-Output $output

}