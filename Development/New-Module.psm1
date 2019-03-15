function New-Module{
	<#
	.Synopsis
    Automates the baseline work for developing a new powershell module fully integrated into the framework
    
	.Description
    Automates the baseline work for developing a new powershell module.
    Fully integrates the module into the module manifests, creates a file in the required location
    
	.Parameter
    ModuleName - name of the module
    
    .Parameter
    ModuleLocation - File location of module. Assume C:\Users\HostHunter

    .Parameter
    Testing - If developer intends to include a Pester Module for testing, this should go there.

	.Example
    New-Module -ModuleName "Test-Module" -ModuleLocation "C:\Users\HostHunter"
    Creates a module called Test-Module.psm1 in C:\Users\HostHunter, adds to manifest list

	#>

	[CmdletBinding()]
	param
	(
        [Parameter(Mandatory=$True)][string]$ModuleName,
        [Parameter(Mandatory=$True)][string]$ModuleLocation,
        [switch]$Testing
    )

    # Setup output variable
    $output = @{
        "ModuleName" = $ModuleName
        "ModuleLocation" = ""
        "Outcome" = ""
    }
    $moduleloc = $ModuleLocation + "\" + $ModuleName + ".psm1"
    $output.ModuleLocation = $moduleloc

    # Get a list of the current modules
    $modulelist = Get-Content -Path $ModulePath | ConvertFrom-Json

    # Confirm a module of the same name does not already exist
    $moduleexists = $false
    if($modulelist | Where-Object {$_.Name -match $ModuleName})
    {
        # if yes, notify the user
        Write-Information -InformationAction Continue -MessageData "Module already exists"
        $message = "Module Location: " + ($modulelist | Where-Object { $_.Name -match $ModuleName }).FileLocation
        Write-Information -InformationAction Continue -MessageData $message
        $moduleexists = $true
        $output.Outcome = "ModuleCreationFailed"
    }else{
        Write-Information -MessageData "Module does not exist. Integrating."
        # Get a copy of the template and put into new location
        Copy-Item -Path "C:\Users\HostHunter\Development\Get-Example.psm1" -Destination $moduleloc -Verbose
        # Add item to module manifest
        Write-Information -InformationAction Continue -MessageData "Adding to manifest"
        $modulelist += @{
            "Name" = $ModuleName
            "FileLocation" = $moduleloc
        }
        $modulelist | ConvertTo-Json| Out-File -FilePath $ModulePath
        $output.Outcome = "ModuleCreationSuccess"
    }

    # todo: add switch for testing
    Write-Output $output
}