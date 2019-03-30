function Get-StandardVMSettings{
	<#
	.Synopsis
    Gets the standard VM settings for OSTypes. 
    
	.Description
    Gets the standard VM settings for OSTypes. Optimised for most amount of VMs, not speed.  
    
	.Parameter
	OSType - the OS Type to be selected 

	.Example
	Get-StandardVMSettings -OSType WindowsServer2016

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string][ValidateSet('WindowsServer2016', 'Windows10Enterprise', 'Ubuntu1804Server', 'Ubuntu1804Client')]$OSType
    )
	
	# Create custom powershell object for output
	$standardvmmanifest = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\standardvmsettings.json | ConvertFrom-Json
	$output = $standardvmmanifest | Where-Object {$_.OSType -eq $OSType}
	
	# Write output to pipeline
	Write-Output $output

}