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

    $moduleloc = $ModuleLocation + "\" + $ModuleName
    Write-Host $moduleloc

    # Get a list of the current modules
    $modulelist = Get-Content -Path "C:\Users\HostHunter\Manifests\modulemanifest.txt"

    # Confirm a module of the same name does not already exist
    $moduleexists = $false
    foreach($module in $modulelist)
    {
        if($ModuleLoc -eq $module){
            Write-Information -MessageData "Module already exists"
            $moduleexists = $true
            Write-Output "Module creation failed"
        }
    }
    # If not found, do the hard work of adding
    if($moduleexists -eq $false)
    {
        Write-Information -MessageData "Module does not exist. Integrating."
        # Get a copy of the template and put into new location
        $moduleloc = $moduleloc + ".psm1"
        Copy-Item -Path "C:\Users\HostHunter\Development\Get-Example.psm1" -Destination $moduleloc -Verbose
        # Add item to module manifest
        Write-Information -InformationAction Continue -MessageData "Adding to manifest"
        $modulelist += $moduleloc
        $modulelist | Out-File -FilePath "C:\Users\HostHunter\Manifests\modulemanifest.txt"
        Write-Output "Module creation succeeded"
    }

    # todo: add switch for testing

}