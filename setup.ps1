#Requires -RunAsAdministrator

# Update Powershell Help
Update-Help

# Check that Pester has been installed and updated
# Pester: https://github.com/pester/Pester
Write-Information -InformationAction Continue -MessageData "Checking Pester Installation"

$pester = Get-Module -ListAvailable -Name Pester

if($pester.Name -ne "Pester")
{
    Write-Information -InformationAction Continue -MessageData "Pester not installed, installing"
    Install-Module -Name Pester -Force -Verbose
}else{
    Write-Information -InformationAction Continue -MessageData "Pester installed, updating"
    Update-Module -Name Pester -Verbose
}

# For databasing, I have chosen SQLite as it is free and works for this task. Many options are available - if cost
# is not an issue, I recommend Splunk.

# Install powershell wrapper for ease of use
# PSSQLite: https://github.com/RamblingCookieMonster/PSSQLite 
$PSSQLite = Get-Module -ListAvailable -Name PSSQLite

if($PSSQLite.Name -ne "PSSQLite"){
    Write-Information -InformationAction Continue -MessageData "SQLLite not installed, installing"
}else{
    Write-Information -InformationAction Continue -MessageData "SQLLite installed"
}

# Check for StartMission script
# Set path
$path = $env:USERPROFILE + "\Documents\HostHunter\startmission.ps1"
$pathcheck = Test-Path $path
if($pathcheck -ne $true){
    Write-Information -InformationAction Continue -MessageData "startmission.ps1 not found. Check install location"
}else{
    Write-Information -InformationAction Continue -MessageData "startmission.ps1 found, ready to continue"
}

# Setup console experience. 
$console = $Host.UI.RawUI
$console.BackgroundColor = "Black"
$console.Foregroundcolor = "Green"

