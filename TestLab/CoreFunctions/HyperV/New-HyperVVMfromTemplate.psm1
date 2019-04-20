function New-HyperVVMfromTemplate{
	<#
	.Synopsis
    Creates a new HyperV Virtual Machine from a template
    
	.Description
    Creates a new HyperV VM from the gold template image
    
	.Parameter
	OSType - The type of OS to be used

	.Example
	New-HyperVVMfromTemplate -OSType Ubuntu1804Server -OSName AnsibleServer

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$OSType, #todo: dynamic params
		[Parameter(Mandatory=$true)][string]$OSName
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		HostName = ""
		OSType = $OSType
		TemplateExists = $false
		Imported = $false
		VMID = ""
		Renamed = $false
	}
	
	# From the OSType selected, confirm that a template exists
	$testlabmanifest = Get-Content -Raw -Path $TestLabManifest | ConvertFrom-Json
	$template = $testlabmanifest | Where-Object {$_.ItemPurpose -eq 'Template'} | Where-Object {$_.ItemOS -eq $OSType}
	if($template)
	{
		$message = "Template exists, creating $OSType as $OSName"
		Write-Information -InformationAction Continue -MessageData $message
		$output.TemplateExists = $true
		# Based upon the OSType selected, Import the VM as a copy
		# Get the Item ID first. Do a dirty string manipulation path. Ewww.
		$path = "C:\Users\HostHunter\TestLab\VirtualMachines\Templates\" + $OSType + "_Template\Virtual Machines\"
		$pathvmcx = $path + "*.vmcx"
		$filename = Get-ChildItem -Path $pathvmcx
		$pathname = $path + $filename.Name
		$virtualmachinepath = "C:\Users\HostHunter\TestLab\VirtualMachines\" + $OSName + "\"
		# Import the VM
		$importvm = Import-VM -Path $pathname -VirtualMachinePath $virtualmachinepath -VhdDestinationPath $virtualmachinepath -Verbose -Copy -GenerateNewId
		$output.VMID = $importvm.Id
		if($importvm)
		{
			Write-Information -InformationAction Continue -MessageData "VM imported successfully, renaming"
			$output.Imported = $true
			# Now rename to the name selected by the user based upon the ID
			Get-VM | Where-Object {$_.Id -eq $output.VMID} | Rename-VM -NewName $OSName -Verbose
			$output.Renamed = $true
			$output.Outcome = "Success"
		}else{
			Write-Information -InformationAction Continue -MessageData "VM Importing did not work"
		}
	}else{
		Write-Information -InformationAction Continue -MessageData "Template does not exist. Create template then retry"
	}
	
	
	# Write output to pipeline
	Write-Output $output

}