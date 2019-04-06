function Rename-HHModule{
	<#
	.Synopsis
    Renames a Host Hunter Framework module
    
	.Description
    Automates the baseline work to rename a module from Host Hunter Framework. 
    Still requires module to renamed in .psm1 file
    
	.Parameter
    ModuleCurrentName - name of the module to be renamed
    
    .Parameter
    ModuleNewName - new name of the module

	.Example
    Rename-HHModule -ModuleCurrentName Test-Module -ModuleNewName Test-HHModule
    Renames a module called Test-Module to Test-HHModulefrom framework 

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True)][string]$ModuleCurrentName,
		[Parameter(Mandatory=$True)][string]$ModuleNewName,
		[Parameter(Mandatory=$True)][string]$NewModulePath
	)

	# Setup output variable
	$output = @{
		"ModuleCurrentName" = $ModuleCurrentName
		"ModuleNewName" = $ModuleNewName
		"Outcome" = ""
	}

	# Get a list of the current modules
	$modulelist = Get-Content -Path $ModulePath | ConvertFrom-Json

	# Confirm module exists
	if($modulelist | Where-Object {$_.Name -eq $ModuleCurrentName})
	{
		# if yes, notify the user
		Write-Information -InformationAction Continue -MessageData "Module exists"
		$message = "Module Location: " + ($modulelist | Where-Object { $_.Name -eq $ModuleCurrentName }).FileLocation
		Write-Information -InformationAction Continue -MessageData $message

		# Create a new array which does not contain removed module
		$newarray = @()
		foreach($module in $modulelist)
		{
			if($module.Name -ne $ModuleCurrentName)
			{
				$newarray += $module
			}
		}
		# Add renamed module and filepath to array
		$newmodulename = @{
			Name = $ModuleNewName
			FileLocation = $NewModulePath + $ModuleNewName + ".psm1"
		}
		
		$newarray += $newmodulename
		
		# Save to module manifest list
		$newarray | ConvertTo-Json | Out-File -FilePath $ModulePath

		# Change file name
		$modulefilepath = ($modulelist | Where-Object { $_.Name -eq $ModuleCurrentName }).FileLocation
		$modulefilepath = $modulefilepath.tostring()
		$ModuleNewName = $ModuleNewName + ".psm1"
		Rename-Item -Path $modulefilepath -NewName $ModuleNewName
		$output.Outcome = "Success"
	}else{
		Write-Information -InformationAction Continue -MessageData "Module does not exist"
		$output.Outcome = "Failed"
	}

	Write-Output $output
}