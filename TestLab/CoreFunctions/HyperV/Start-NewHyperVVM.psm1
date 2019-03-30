function Start-NewHyperVVM{
	<#
	.Synopsis
    Starts a freshly created VM for the first time. Used when no template is available
    
	.Description
    Starts a freshly created VM for the first time. Used when no template is available
    Makes heavy use of this site:
    https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine
    
	.Parameter
	VMName - Name of the VM being created

	.Example
	Start-NewHyperVVM -VMName HostHunter

	#>

	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$true)][string]$VMName,
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10Enterprise', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
	}
	
	# Get VM Standard Settings
	$settings = Get-StandardVMSettings -OSType $OSType
	$isolocation = $settings.ISOLocation
	
	# Connect DVD Drive
	Add-VMScsiController -VMName $VMName
	Add-VMDvdDrive -VMName $VMName -ControllerNumber 0 -ControllerLocation 1 -Path $isolocation
		
	# Start VM
	Start-VM -Name $VMName
	
	# Connect to vm
	vmconnect.exe localhost $VMName
	
	$output.Outcome = "Success"
	
	# Write output to pipeline
	Write-Output $output

}