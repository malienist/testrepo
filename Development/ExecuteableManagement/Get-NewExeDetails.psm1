function Get-NewExeDetails{
	<#
	.Synopsis
    When a new executable has been added to the framework, inputs all the details to ensure integrated effectively.
    
	.Description
	When a new executable has been added to the framework, ensures all integration issues are completed.
	1. Adds executable to executable manifest through New-Executable module
	2. Gets hash values for executable when not provided by downloading and hashing

	.Parameter
	ExeName - the name of the executable to be added. Should be copied directly from the website

	.Parameter
	ExeURL - URL of the exe to download

	.Example
	Get-NewExeDetails -ExeName winpmem_1.6.2.exe -ExeURL http://releases.rekall-forensic.com/v1.3.1/winpmem_1.6.2.exe

	#>

	[CmdletBinding()]
	param
	(
        $ExeName,
		$ExeURL,
		$ExeRole
    )

	# First, download executable
	Write-Information -InformationAction Continue -MessageData "Getting executable"
	$filepath = "C:\Users\HostHunter\Executeables\$ExeName"
	Get-WebExecuteable -URL $ExeURL -Outfile C:\Users\HostHunter\Executeables\$ExeName -BITS

	# Get details of executable
	Write-Information -InformationAction Continue "Getting details"
	$MD5hash = Get-FileHash -Path $filepath -Algorithm MD5
	$Sha256 = Get-FileHash -Path $filepath -Algorithm SHA256

	# Now add to executable list
	New-Executeable -ExeName $ExeName -ExeSha256Hash $Sha256.Hash -ExeMD5Hash $MD5hash.Hash -ExeURL $ExeURL -ExeRole $ExeRole
	
	# todo: needs to delete all the different elements if something fails
}


