function Move-ModuleLocation{
	<#
	.Synopsis
    Moves a module from current location to new location, while ensuring full integration to the framework.
    
	.Description
	Moves a module from current location to new location. Ensures the following integration:
	1. Updates module manifest
	2. Moves .psm1 file to new location
	3. Removes old .psm1 file
	4. Reloads framework
    
	.Parameter
	CurrentLocation - the current location of module. Must be full path including filename.

	.Parameter
	NewLocation - the new location of module. Must be full path including filename.

	.Example
	Move-ModuleLocation -CurrentLocation 'C:\Users\HostHunter\Development\New-Executable.psm1 -NewLocation 'C:\Users\HostHunter\SetupScripts\ExecutableManagement\New-Executable.psm1'

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][String]$ModuleName,
		[Parameter(Mandatory=$true)]$NewLocation
	)

	# Setup output variable
	$output = @{
		Exists = ''
		Move = ''
		Result = ''
	}
	
	# Set up complete filename
	$newlocation = $NewLocation + $ModuleName + ".psm1"
	
	# First, check if module in current location works. 
	Write-Information -InformationAction Continue -MessageData "Checking file location"
	$modulelist = Get-Content -Raw -Path $ModulePath | ConvertFrom-Json
	$path = ($modulelist | Where-Object {$_.Name -eq $ModuleName}).FileLocation
	$currentpath = Test-Path -Path $Path
	$output.Exists = $currentpath
	if($output.Exists -eq $true)
	{
		Write-Verbose -Message "Path exists, moving"
		# If module exists, move to new location
		Move-Item -Path $path -Destination $NewLocation
		# Test new path to ensure move successful
		$newpath = Test-Path -Path $NewLocation
		$output.Move = $newpath
		# If module moved successfully, update the module manifest
		if($output.Move -eq $true)
		{
			# Update hashtable
			($modulelist | Where-Object {$_.Name -eq $ModuleName}).FileLocation = $NewLocation
			$newmanifest = $modulelist
			# Write hash table back to .json file
			$newmanifest | ConvertTo-Json | Out-File $ModulePath
			$output.Result = "Successful"
		}else{
			Write-Information -InformationAction Continue -MessageData "Error in moving module. Not successful"
			$output.Result = "Unsuccessful"
		}
	}else{
		Write-Information -=-InformationAction Continue -MessageData "Path does not exist"
		$output.Result = "Unsuccessful"
	}

	Write-Output $output

}