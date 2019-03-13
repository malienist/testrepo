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
		$CurrentLocation,
		$NewLocation
	)

	# Setup output variable
	$output = @{
		Exists = ''
		Move = ''
		Result = ''
	}
	
	# First, check if module in current location works. 
	Write-Information -InformationAction Continue -MessageData "Checking file location"
	$currentpath = Test-Path -Path $CurrentLocation
	$output.Exists = $currentpath
	if($currentpath -eq $true)
	{
		Write-Verbose -Message "Path exists, moving"
		# If module exists, move to new location
		Move-Item -Path $CurrentLocation -Destination $NewLocation
		# Test new path to ensure move successful
		$newpath = Test-Path -Path $NewLocation
		$output.Move = $newpath
		# If module moved successfully, update the module manifest
		if($output.Move -eq $true)
		{
			$manifest = Get-Content -Path C:\Users\HostHunter\Manifests\modulemanifest.txt
			# Create new module array
			# Find the module being moved
			foreach($module in $manifest)
			{
				if($CurrentLocation -like $module)
				{
					$newmanifest += $NewLocation
				}else{
					$newmanifest += $module
				}
			}
			# Sort alphabetically (because I'm fairly particular that way :P)
			$newmanifest = $newmanifest | Sort-Object
			# Remove current manifest
			Write-Verbose -Message "Removing current manifest"
			Remove-Item -Path C:\Users\HostHunter\Manifests\modulemanifest.txt
			# Put new array back into the module manifest
			$newmanifest | Out-File -FilePath C:\Users\HostHunter\Manifests\modulemanifest.txt
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