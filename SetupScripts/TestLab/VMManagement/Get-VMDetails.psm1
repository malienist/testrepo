function Get-VMDetails{
	<#
	.Synopsis
    Gets the details of the specified virtual machine.
    
	.Description
    Gets the details of the specified virtual machine from JSON manifest
    
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
	
	# Get the list of virtual machines
	$testlab = Get-Content -Raw -Path $TestLabManifest | ConvertFrom-Json
	$vm = $testlab | Where-Object {$_.HostName -eq $HostName}
	if($vm){
		Write-Output $vm
	}else{
		Write-Information -InformationAction Continue -MessageData "No Virtual Machine with that HostName in TestLab"
	}

}