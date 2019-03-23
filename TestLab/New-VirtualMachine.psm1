function New-VirtualMachine{
	<#
	.Synopsis
    Base virtual machine creation
    
	.Description
    Creates virtual machine from provided template
    
	.Parameter
	Type - 

	.Example
	New-VirtualMachine -Type WindowsServer

	#>

	[CmdletBinding()]
	param
	(
		[parameter(Mandatory=$true)][string]$VMName,
        [switch]$WindowsServer,
		[switch]$Windows10Client
    )
	
	# Create custom powershell object for output
	$output = @{
		"Outcome" = "Failed"
		"VMType" = ""
		"VMName" = $VMName
	}
	
	# Depending on the switch selected, create virtual machine
	if($WindowsServer)
	{
		Write-Information -InformationAction Continue -MessageData "Creating Windows Server machine"
		Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} | New-VMXClone -BaseSnapshot WindowsServerTemplate -CloneName $VMName
		# Once finished, call Get-VMX to check machine created
		$VM = Get-VMX | Where-Object {$_.VMXName -eq $VMName}
		if($VM)
		{
			Write-Information -InformationAction Continue -MessageData "Server created successfully"
			$output.VMType = "WindowsServer"
			$output.Outcome = "Success"
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}