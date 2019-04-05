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
		[Parameter(Mandatory=$True)][string]$ModulePath
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
	$moduleexists = $false
	if($modulelist | Where-Object {$_.Name -eq $ModuleName})
	{
		# if yes, notify the user
		Write-Information -InformationAction Continue -MessageData "Module exists"
		$message = "Module Location: " + ($modulelist | Where-Object { $_.Name -match $ModuleName }).FileLocation
		Write-Information -InformationAction Continue -MessageData $message

		# Create a new array which does not contain removed module
		$newarray = @()
		foreach($module in $modulelist)
		{
			if($module.Name -ne $ModuleName)
			{
				$newarray += $module
			}else{
				# Change the name of the module
				$module.Name = $ModuleNewName
				# Update the file path to reflect new name
				$moduleloc = $ModulePath + $ModuleNewName + ".psm1"
				$module.FileLocation = $moduleloc
				$newarray += $module
			}
		}
		# Save to module manifest list
		$newarray | ConvertTo-Json | Out-File -FilePath $ModulePath

		# Change file name
		$modulepath = ($modulelist | Where-Object { $_.Name -match $ModuleName }).FileLocation
		Rename-Item -Path $ModulePath -NewName $ModuleNewName
		$output.Outcome = "Success"
	}else{
		Write-Information -MessageData "Module does not exist"
		$output.Outcome = "Failed"
	}

	Write-Output $output
}