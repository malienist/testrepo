function Get-CoreExecuteables{
	<#
	.Synopsis
	Gets the core executeables for HostHunter
    
	.Description
    Gets all core executeables listed at core in executeable manifest
    Core defined as those executeables used to ensure Base VM can be used for development
    
	.Example
	Get-CoreExecuteables

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	Write-Information -InformationAction Continue -MessageData "Confirming all core executeables available"
	
	# Get Executeable Manifest
	$executeables = Get-Content -Raw -Path $ExecuteableLocation | ConvertFrom-Json
	
	# Confirm the location of all core executeables in the executeable folder if executeable is listed as core
	foreach($exe in $executeables)
	{
		if($exe.ExeRole -eq "Core")
		{
			$exepath = "C:\Users\HostHunter\Executeables\" + $exe.ExeName
			$exists = Test-Path -Path $exepath
			if(-not $exists)
			{
				$message = $exe.ExeName + " does not exist. Downloading."
				Write-Information -InformationAction Continue -MessageData $message
				Get-WebExecuteable -URL $exe.URL -OutFile $exepath -Hash $exe.Sha256Hash
			}
		}
	}

}