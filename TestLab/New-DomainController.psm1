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
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$DCName,
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$DCIP
    )
	
	# Create custom powershell object for output
	$output = @{
		Outcome = "Failed"
		DCName = $DCName
		FileTransfer = ""
		FileName = ""
		FileHash = ""
		
	}
	
	# Create a new Server VM
	$DCVM = New-VirtualMachine -VMName $DCName -WindowsServer
	if($DCVM.Outcome -eq "Success")
	{
		# Compile DSC resource 
		. ./Configurations/StandardDC.ps1
		
		# Publish to a remote machine
		Publish-DscConfiguration -Path C:\Users\HostHunter\TestLab\Configurations\StandardDC.ps1 -ComputerName $DCVM.VMIPAddress -Credential (Get-Credential	)
	}
	
	# Install the required modules on remote machine 
	# Get Credentials 
	$cred = Get-Credential -Message "Input local credentials for Domain Controller"
	# Install xActiveDirectory
	Invoke-Command -ComputerName $DCIP -Credential $cred -ScriptBlock{Install-Module -Name xActiveDirectory}
	
	
	# Ready file transfer. Note that at this point logical accountability server has not been established, so command details stored on disk.
	# These will be processed once the logical accountability server is setup
	$localfilepath = "C:\Users\HostHunter\TestLab\Configurations\StandardDC.ps1"
	$targetfilepath = "StandardDC.ps1"
	# note this is stored in C:\Windows\System32\StandardDC.ps1
	Invoke-InitialWinRMFileTransfer -ComputerName $DCIP -LocalFilePath $localfilepath -TargetFilePath $targetfilepath
	
	# Write output to pipeline
	Write-Output $output

}