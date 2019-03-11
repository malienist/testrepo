#Requires -RunAsAdministrator
#Requires -Version 5.1

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
# Microsoft documentation page: https://docs.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=netframework-4.7.2

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

# Install databasing function so actions can be recorded effectively
Write-Information -InformationAction Continue -MessageData "Setting up databasing"
# Get SQLite executable
Get-WebExecutable -URL https://www.sqlite.org/2019/sqlite-tools-win32-x86-3270200.zip -Outfile C:\Users\HostHunter\Executables\sqlite.zip
# Unzip executable
Open-ZipFile -ZipFile C:\Users\HostHunter\Executables\sqlite.zip -ExtractionLoc C:\Users\HostHunter\Databasing\
# Move executable to Databasing subfolder
Move-Item C:\Users\HostHunter\Databasing\sqlite-tools-win32-x86-3270200\sqlite3.exe -Destination C:\Users\HostHunter\Databasing\sqlite3.exe
# Remove zip file
Remove-Item -Path C:\Users\HostHunter\Executables\sqlite.zip
# Install PSSQLite module
Install-Module PSSQLite