#Requires -RunAsAdministrator
#Requires -Version 5.1

# Update Powershell Help
Write-Information -InformationAction Continue -MessageData "Updating Help"
Update-Help

# Ensure WinRM services is running
Write-Information -InformationAction Continue -MessageData "Ensuring Powershell Remoting works"
$outcome = "n"
while($outcome -ne "y")
{
    $outcome = Read-Host "Is network connection profile not set to Public(y/n)"
    if($outcome -eq "n")
    {
        Write-Information -InformationAction Continue -MessageData "Follow this process to set to private"
        Write-Information -InformationAction Continue -MessageData "Get current network connection profile index: Get-NetconnectionProfile"
        Write-Information -InformationAction Continue -MessageData "Using desired network, set to private: Set-NetconnectionProfile -InterfaceIndex <index number> -NetworkCategory Private"
        Write-Information -InformationAction Continue -MessageData "Confirm network connection profile changed: Get-NetconnectionProfile"
    }
}

Write-Information -InformationAction Continue -MessageData "Setting up PSRemoting"
Enable-PSRemoting -Force
Set-Item WSMan:localhost\client\TrustedHosts *

# Import DSC module
Write-Information -InformationAction Continue -MessageData "Configuring Base VM"
Import-Module C:\Users\HostHunter\SetupScripts\Set-BaseVMFileStructure.psm1 -Force

# Now configure BaseVM
# Set-BaseVMFileStructure

# Now change the permissions on this folder and all subfolders so that user (i.e. me) can freely 
# access and save it. Many thanks to this website: https://blogs.msdn.microsoft.com/johan/2008/10/01/powershell-editing-permissions-on-a-file-or-folder/
# and https://stackoverflow.com/questions/33234047/powershell-how-to-give-full-access-a-list-of-local-user-for-folders
# Microsoft documentation page: https://docs.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=netframework-4.7.2

Write-Information -InformationAction Continue -MessageData "Updating Folder Permissions"
$ACL = Get-Acl -Path C:\Users\HostHunter
$NewACL = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
Set-ACL -Path C:\Users\HostHunter\ $ACL

# Import all modules into current command shell
Write-Information -InformationAction Continue -MessageData "Importing powershell modules"
.\reload.ps1

# With virtualization preference set, setup test lab
Write-Information -InformationAction Continue -MessageData "Setting up TestLab"
# Get the ISOs and move to the framework file location
while($windowsserverisopresent -ne $true)
{
    $windowsserverISO = Read-Host "File name for WindowsServer2016 ISO (include .iso)"
    $isopath = $env:USERPROFILE + "\Downloads\" + $windowsserverISO
    $windowsserverisopresent = Test-Path -Path $isopath
    if($windowsserverisopresent -ne $true)
    {
        Write-Information -InformationAction Continue -MessageData "File not found, try again"
    }
}
if($windowsserverisopresent -eq $true)
{
    # Move to ISO file location
    $destination = "C:\Users\HostHunter\TestLab\ISOs\" + $windowsserverISO
    Write-Information -InformationAction Continue -MessageData "Moving Windows Server 2016 ISO into HostHunter Framework"
    Move-Item -Path $isopath -Destination $destination
    # Get the Hash
    $ISOHash = Read-Host "Hash for Windows Server 2016"
    # Get the HashType
    $ISOHashType = Read-Host "HashType - options SHA1, SHA2, SHA256, MD5"
    # Confirm this is accurate
    $hash = Get-FileHash -Algorithm $ISOHashType -Path $destination
    if($hash.Hash -eq $ISOHash)
    {
        # Add to iso manifest
        New-ISOFile -ISOFileName $windowsserverISO -ISOOS "WindowsServer2016" -ISOHash $ISOHash -ISOHashType $ISOHashType
    }
    else
    {
        Write-Information -InformationAction Continue -MessageData "Incorrect Hash"
        break
    }
    
}

# Windows 10
while($windows10Enterpriseisopresent -ne $true)
{
    $windows10EnterpriseISO = Read-Host "File name for Windows10Enterprise ISO (include .iso)"
    $isopath = $env:USERPROFILE + "\Downloads\" + $windows10EnterpriseISO
    $windows10Enterpriseisopresent = Test-Path -Path $isopath
    if($windows10Enterpriseisopresent -ne $true)
    {
        Write-Information -InformationAction Continue -MessageData "File not found, try again"
    }
}

if($windows10Enterpriseisopresent -eq $true)
{
    $destination = "C:\Users\HostHunter\TestLab\ISOs\" + $windows10EnterpriseISO
    Write-Information -InformationAction Continue -MessageData "Moving Windows 10 Enterprise ISO into HostHunter Framework"
    Move-Item -Path $isopath -Destination $destination
    # Get the Hash
    $ISOHash = Read-Host "Hash for Windows 10 Enterprise"
    # Get the HashType
    $ISOHashType = Read-Host "HashType - options SHA1, SHA2, SHA256, MD5"
    # Confirm this is accurate
    $hash = Get-FileHash -Algorithm $ISOHashType -Path $destination
    if($hash.Hash -eq $ISOHash)
    {
        # Add to iso manifest
        New-ISOFile -ISOFileName $windows10EnterpriseISO -ISOOS "Windows10Enterprise" -ISOHash $ISOHash -ISOHashType $ISOHashType
    }
    else
    {
        Write-Information -InformationAction Continue -MessageData "Incorrect Hash"
        break
    }
}
# Ubuntu Server
while($ubuntu1804serverisopresent -ne $true)
{
    $ubuntu1804serverISO = Read-Host "File name for Ubuntu 1804 Server ISO (include .iso)"
    $isopath = $env:USERPROFILE + "\Downloads\" + $ubuntu1804serverISO
    $ubuntu1804serverisopresent = Test-Path -Path $isopath
    if($ubuntu1804serverisopresent -ne $true)
    {
        Write-Information -InformationAction Continue -MessageData "File not found, try again"  
    }
}
if($ubuntu1804serverisopresent -eq $true)
{
    $destination = "C:\Users\HostHunter\TestLab\ISOs\" + $ubuntu1804serverISO
    Write-Information -InformationAction Continue -MessageData "Moving Ubuntu 1804 Server ISO into HostHunter Framework"
    Move-Item -Path $isopath -Destination $destination
    # Get the Hash
    $ISOHash = Read-Host "Hash for Ubuntu 1804 Server"
    # Get the HashType
    $ISOHashType = Read-Host "HashType - options SHA1, SHA2, SHA256, MD5"
    # Confirm this is accurate
    $hash = Get-FileHash -Algorithm $ISOHashType -Path $destination
    if($hash.Hash -eq $ISOHash)
    {
        # Add to iso manifest
        New-ISOFile -ISOFileName $ubuntu1804serverISO -ISOOS "Ubuntu1804Server" -ISOHash $ISOHash -ISOHashType $ISOHashType
    }
    else
    {
        Write-Information -InformationAction Continue -MessageData "Incorrect Hash"
        break
    }
}

# Set the virtualization preference
# todo: make this more robust
Write-Information -InformationAction Continue -MessageData "Currently available virtualization integration: HyperV"
$virtualization = Read-Host "Set virtualisation preference (HyperV)"
if($virtualization -eq "HyperV")
{
    Set-VirtualisationPreference -VirtualisationPreference $virtualization
}
else
{
    Write-Information -InformationAction Continue -MessageData "Invalid entry selected"
    break
}

# Build template VMs
Write-Information -InformationAction Continue -MessageData "Building template VMs"
Build-TestLabTemplates

# Confirm if Ansible Server to be created locally or remote
$ansiblelocation = Read-Host "Is ansible server remote or local (remote/local)" #todo: Input validation
if($ansiblelocation -eq "remote")
{
    # If remote, store in the manifest as remote for future reference
    Write-Information -InformationAction Continue -MessageData "ansible stored in remote location (user selected)"
    # Get details of remote ansible server from user
    $remotehostname = Read-Host "ansible server hostname"
    $remoteip = Read-Host "ansible server IP address"
    $remoteconfigurationenabled = Read-Host "ansible server remote configuration enabled (true/false)"
    if($remoteconfigurationenabled -eq "true")
    {
        $remoteconfigurationenabled -eq $true
    }else{
        $remoteconfigurationenabled -eq $false
    }
    New-TestLabManifestItem -ItemOS 'Ubuntu1804Server' -ItemPurpose 'Ansible' -ItemFileLocation 'Remote' -ItemName $remotehostname -ItemRemoteConfigurationType 'SSH' -ItemRemoteConfigurationEnabled $remoteconfigurationenabled -ItemSMB $false -ItemIPAddress $remoteip
}elseif($ansiblelocation -eq "local")
{
    # Check if ansible server exists in manifest
    $testlab = Get-Content -Raw -Path $testlabmanifest | ConvertFrom-Json
    if($testlab | Where-Object {$_.ItemPurpose -eq 'ansible'})
    {
        Write-Information -InformationAction Continue -MessageData "ansible server already created"
    }else{
        Write-Information -InformationAction Continue -MessageData "Creating ansible server"
        
    }
}

### Future work once framework in operation
# Ensure all core executeables have been downloaded
<#
Get-CoreExecuteables

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
# Unzip executable
#Open-ZipFile -ZipFile C:\Users\HostHunter\Executables\sqlite.zip -ExtractionLoc C:\Users\HostHunter\Databasing\
# Move executable to Databasing subfolder
#Move-Item C:\Users\HostHunter\Databasing\sqlite-tools-win32-x86-3270200\sqlite3.exe -Destination C:\Users\HostHunter\Databasing\sqlite3.exe
# Remove zip file
#Remove-Item -Path C:\Users\HostHunter\Executables\sqlite.zip
# Install PSSQLite module
# Install-Module PSSQLite

# Install Core Executeables
Set-BaseVMCoreExecuteables

# Install Core Modules from other sources for Framework
# Install PSWindowsUpdate - used to help automate the management of test lab. Note this is an untrusted repository
# so up to user to decide if they want to use it.
# I strongly recommned you read and understand the documents for this - a good start is:
# https://4sysops.com/archives/install-windows-updates-remotely-with-the-powershell/
Install-Module PSWindowsUpdate

# Install Active Directory DSC resource
# https://www.powershellgallery.com/packages/xActiveDirectory/2.24.0.0

Install-Module -Name xActiveDirectory
#>

