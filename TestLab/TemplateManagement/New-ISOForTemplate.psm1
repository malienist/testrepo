function New-ISOForTemplate{
	<#
	.Synopsis
    Updates the ISO Manifest with new ISOs for templates, moves ISOs into host framework.
    
	.Description
    Updates the ISO Manifest with new ISOs for templates, moves ISOs into host framework.
    Dynamic Parameters used: https://docs.microsoft.com/en-au/powershell/module/microsoft.powershell.core/about/about_functions_advanced_parameters?view=powershell-5.1
    Also: https://mcpmag.com/articles/2016/10/06/implement-dynamic-parameters.aspx
    
	.Parameter
	[string]$ISOLocation - file location of ISOs. Default is user downloads
	
	.Parameter
	[string]$ISOName - Name of ISO in the specified folder
	
	.Parameter
	[string]$OSFamily - family of OS ISO comes from
	
	.Parameter
	[string]$OSType - the type of OS used 
	
	.Parameter
	[string]$OSHash - Hash of the OS being used
	
	.Parameter
	[string]$HashType - The type of has algorithm being used by OS

	.Example
	New 
	

	#>

	[CmdletBinding()]
	param
	(
        [string]$ISOLocation = "Downloads",
		[Parameter(Mandatory=$true)][string]$ISOName,
		[ValidateSet('Windows', 'Unix')]$OSFamily,
		[Parameter(Mandatory=$true)][string]$OSType,
		[string]$OSHash
    )
	
	$output = @{
		Outcome = "Failed"
		ISOExists = $false
		ISOHashMatch = $false
		ISOTransferred = "Failed"
		ISOAddedtoManifest = $false
	}
	
	# Get ISO file
	if($ISOLocation -eq "Downloads")
	{
		$path = $env:USERPROFILE + "\Downloads\" + $ISOName
	}else{
		$path = $ISOLocation + $ISOName
	}
	
	# Confirm file exists
	$pathtest = Test-Path -Path $path
	
	# If path exists, transfer to Host Hunter Framework
	if($pathtest -eq $true)
	{
		$output.ISOExists = $true
		# Move to HostHunter Framework
		$destination = "C:\Users\HostHunter\TestLab\ISOs\" + $ISOName
		$message = "Moving $OSType ISO to TestLab ISO location"
		Write-Information -InformationAction Continue -MessageData $message
		Move-Item -Path $isopath -Destination $destination -Verbose
		$output.ISOTransferred = "Success"
		# If hash not provided, get Sha256 Hash
		if(-not $OSHash)
		{
			$OSHash = Get-FileHash -Algorithm SHA256 -Path $destination
			$algorithmtype = "SHA256"
		}else{
			$algorithmtype = Read-Host "HashType - options SHA1, SHA2, SHA256, MD5"
		}
		# Confirm hashes match
		$hash = Get-FileHash -Algorithm $algorithmtype -Path $destination
		if($hash.Hash -eq $OSHash)
		{
			$output.ISOMatch = $true
			# Add to iso manifest
			New-ISOFile -ISOFileName $ISOName -ISOOS $OSType -ISOHash $OSHash -ISOHashType $algorithmtype
			$output.ISOAddedtoManifest = $true
			$output.Outcome = "Success"
		}
		
	}else{
		Write-Information -InformationAction Continue -MessageData "File not found"
	}
	Write-Output $output
}