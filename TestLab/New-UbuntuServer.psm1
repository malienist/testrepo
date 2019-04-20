function New-UbuntuServer{
	<#
	.Synopsis
    Creates a new Ubuntu server from gold template
    
	.Description
    Creates a new Ubuntu Server from a gold template using the selected method of virtualization

	.Example
	New-UbuntuServer

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][string]$OSName
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		$outcome = "Failed"
		$newvmdetails = ""
	}
	
	# Create VM using chosen method of virtualization
	if($VirtualizationType -eq 'HyperV')
	{
		$newvm = New-HyperVVMfromTemplate -OSType Ubuntu1804Server -OSName $OSName
		if($newvm.Outcome -eq "Success")
		{
			$output.Outcome = "Success"
			$output.newvmdetails = $newvm
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}