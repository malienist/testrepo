<#
    .Synopsis
    Main mission start for framework. 

    .Detail
    Main mission start for framework. Requires powershell version 6 (in the future greater) so that it runs
    on powershell core. 
#>

#Requires -Version 6
#Requires -RunAsAdministrator

Write-Information -InformationAction Continue -MessageData "HostHunter starting"

# Update help to ensure latest setting
Write-Information -InformationAction Continue -MessageData "Updating help"

# Load Modules
Write-Information -InformationAction Continue -MessageData "Importing powershell modules"
$modules = Get-Content C:\Users\HostHunter\Manifests\modulemanifest.txt
foreach($line in $modules){
    $ImportString = "Importing: " + $line.tostring()
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line -Force
}

