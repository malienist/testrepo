function New-DomainController{
	<#
	.Synopsis
    Creates a new Domain Controller
    
	.Description
    Creates a new Domain Controller from the Server Template. Does not create users etc.
    
    .Parameter
    DCName - Name of the DC (will also be used to setup the domain)

	.Example
	New-DomainController

	#>

	[CmdletBinding()]
	param
	(
        $DCName
    )
	
	# Create custom powershell object for output
	$output = @{
		Outcome = "Failed"
		DCName = $DCName
	}
	
	#### Creating Certificates ####
	# https://docs.microsoft.com/en-us/powershell/dsc/pull-server/secureMOF
	
	# First, see if a key has been created
	
	
	# Create a new Server VM
	$DCVM = New-VirtualMachine -VMName $DCName -WindowsServer
	if($DCVM.Outcome -eq "Success")
	{
		# Compile DSC resource 
		. ./Configurations/StandardDC.ps1
		
		# Publish to a remote machine
		Publish-DscConfiguration -Path C:\Users\HostHunter\TestLab\Configurations\StandardDC.ps1 -ComputerName $DCVM.VMIPAddress -Credential (Get-Credential	)
	}
	
	# Write output to pipeline
	Write-Output $output

}