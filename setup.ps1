#Requires -RunAsAdministrator

# Update Powershell Help
# Update-Help

# Import DSC module
Write-Information -InformationAction Continue -MessageData "Configuring Base VM"
Import-Module .\HelpFunctions\Set-BaseVMFileStructure.psm1 -Force

# Now configure BaseVM
Set-BaseVMFileStructure

# Now change the permissions on this folder and all subfolders so that user (i.e. me) can freely 
# access and save it. Many thanks to this website: https://blogs.msdn.microsoft.com/johan/2008/10/01/powershell-editing-permissions-on-a-file-or-folder/
# and https://stackoverflow.com/questions/33234047/powershell-how-to-give-full-access-a-list-of-local-user-for-folders

Write-Information -InformationAction Continue -MessageData "Updating Folder Permissions"
$ACL = Get-Acl -Path C:\Users\HostHunter
$NewACL = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
Set-ACL -Path C:\Users\HostHunter\ $ACL

# Import all modules into current command shell
Write-Information -MessageData "Importing powershell modules"
$modules = Get-Content C:\Users\HostHunter\Manifests\modulemanifest.txt
foreach($line in $modules){
    $ImportString = "Importing: " + $line.tostring()
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line -Force
}



# Install Pester
Write-Information -InformationAction Continue -MessageData "Checking Pester Installation"
$pester = Get-Module -ListAvailable -Name Pester
# todo: Figure out how to update Pester. Will require Pester to manage their code differently
if($pester.Name -ne "Pester")
{
    Write-Information -InformationAction Continue -MessageData "Pester not installed, installing"
    Install-Module -Name Pester -Force -Verbose
}else{
    Write-Information -InformationAction Continue -MessageData "Pester exists, continuing"
}

Write-Information -InformationAction Continue -MessageData "Updated"
# Now move all files / modules to directory structure created
#Copy-Item -Path .\HelpFunctions\*.psm1 -Destination C:\Users\HostHunter\HelpFunctions
#Copy-Item -Path .\modulemanifest.txt -Destination C:\Users\HostHunter\modulemanifest.txt



# Download mongodb for databasing
#Write-Information -InformationAction Continue -MessageData "Downloading mongodb"
#Get-WebExecutable -URL https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.6-signed.msi -Outfile "C:\Users\HostHunter\Executables\mongodb.msi"

