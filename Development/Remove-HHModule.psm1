function Remove-HHModule{
	<#
	.Synopsis
    Removes a module from HostHunter framework
    
	.Description
    Automates the baseline work to remove a module from the Host Hunter Framework
    
	.Parameter
    ModuleName - name of the module to be removed

	.Example
    Remove-HHModule -ModuleName Test-HHModule
    Removes a module called Test-HHModule from framework 

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$True)][string]$ModuleName
	)

	# Setup output variable
	$output = @{
		"ModuleName" = $ModuleName
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
			}
		}
		# Save to module manifest list
		$newarray | ConvertTo-Json | Out-File -FilePath $ModulePath
		
		# Now remove file from framework
		$path = ($modulelist | Where-Object { $_.Name -match $ModuleName }).FileLocation
		$removal = Remove-Item -Path $path
		$output.Outcome = "Success"
	}else{
		Write-Information -MessageData "Module does not exist"
		$output.Outcome = "Failed"
	}
	
	Write-Output $output
}