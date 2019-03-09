#Requires -RunAsAdministrator

# Update Powershell Help
# Update-Help

# Import DSC module
Write-Information -InformationAction Continue -MessageData "Configuring Base VM"
<<<<<<< HEAD
Import-Module .\HelpFunctions\Set-BaseVMFileStructure.psm1 -Force

# Now configure BaseVM
Set-BaseVMFileStructure

# Import all modules into current command shell
Write-Information -MessageData "Importing powershell modules"
$modules = Get-Content C:\Users\HostHunter\Manifests\modulemanifest.txt
foreach($line in $modules){
    $ImportString = "Importing: " + $line.tostring()
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line -Force
}


=======
Import-Module .\HelpFunctions\Set-BaseVM.psm1 -Force

# Now configure BaseVM
Set-BaseVM
>>>>>>> 1daeefe1701a361f40a3a30f5525b917f345c2d2

# Install Pester
Write-Information -InformationAction Continue -MessageData "Checking Pester Installation"
$pester = Get-Module -ListAvailable -Name Pester
# todo: Figure out how to update Pester. Will require Pester to manage their code differently
if($pester.Name -ne "Pester")
{
    Write-Information -InformationAction Continue -MessageData "Pester not installed, installing"
    Install-Module -Name Pester -Force -Verbose
}

# Now move all files / modules to directory structure created
<<<<<<< HEAD
#Copy-Item -Path .\HelpFunctions\*.psm1 -Destination C:\Users\HostHunter\HelpFunctions
#Copy-Item -Path .\modulemanifest.txt -Destination C:\Users\HostHunter\modulemanifest.txt



# Download mongodb for databasing
#Write-Information -InformationAction Continue -MessageData "Downloading mongodb"
#Get-WebExecutable -URL https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.6-signed.msi -Outfile "C:\Users\HostHunter\Executables\mongodb.msi"
=======
Copy-Item -Path .\HelpFunctions\*.psm1 -Destination C:\Users\HostHunter\HelpFunctions
Copy-Item -Path .\modulemanifest.txt -Destination C:\Users\HostHunter\modulemanifest.txt

# Import all modules into current command shell
$modules = Get-Content C:\Users\HostHunter\modulemanifest.txt
$root = "C:\Users\HostHunter\"
foreach($line in $modules){
    $ImportString = "Importing: " + $line.tostring()
    Write-Information -InformationAction Continue -MessageData $ImportString
    $module = $root + $line
    Import-Module $module -Force
}

# Download mongodb for databasing
Write-Information -InformationAction Continue -MessageData "Downloading mongodb"
Get-WebExecutable -URL https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.6-signed.msi -Outfile "C:\Users\HostHunter\Executables\mongodb.msi"
>>>>>>> 1daeefe1701a361f40a3a30f5525b917f345c2d2

