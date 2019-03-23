function New-VirtualMachine{
	<#
	.Synopsis
    Base virtual machine creation
    
	.Description
    Creates virtual machine from provided template. Does not store 
    
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
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		VMType = ""
		VMName = $VMName
		VMIPAddress = ""
	}
	
	# Depending on the switch selected, create virtual machine
	if($WindowsServer)
	{
		Write-Information -InformationAction Continue -MessageData "Creating Windows Server machine"
		$newclone = Get-VMX | Where-Object {$_.VMXName -eq "HostHunter"} | New-VMXClone -BaseSnapshot $WindowsServerTemplate -CloneName $VMName
		# Once finished, call Get-VMX to check machine created
		$VM = Get-VMX | Where-Object {$_.VMXName -eq $VMName}
		if($VM)
		{
			Write-Information -InformationAction Continue -MessageData "Server created successfully"
			$output.VMType = "WindowsServer"
			$output.Outcome = "Success"
		}
	}
	
	# Start the VM
	$start = Get-VMX | Where-Object {$_.VMXName -eq $VMName} | Start-VMX
	
	# Wait for 30 seconds for boot process
	Write-Information -InformationAction Continue -MessageData "Starting Server, wait for 40 seconds"
	Start-Sleep -s 40
	
	# Get the IP Addresses
	$ips = Get-VMX | Get-VMXIPAddress
	
	# Get details of the VM to return to the pipeline
	$output.VMIPAddress = ($ips | Where-Object {$_.VMXName -eq $VMName}).IPAddress
	
	# Write output to pipeline
	Write-Output $output

}