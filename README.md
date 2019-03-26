# HostHunterCore
Powerful Windows Management Framework Core hunting framework.

Build with a combination of Powershell, Python 2/3, C#, C/C++, Ansible and DSC, the Host Hunter framework enables enterprise level Hypothesis Driven hunting. The framework ensures minimal artifacts, strong accountability and tighly controlled information types. All tactics and techniques hunted for are based upon open source research.

## Core Assumptions
1. True hypothesis driven hunting requires a consistent lab for testing. 
  -> Host Hunter uses a combination of Ansible and DSC to enact declarative programming principles in lab and ensuring a standard, repetitive environment. This environment can be rapidly modified to recreate the desired aspects of a given network.
2. Controlling the impact of hunting activities on a network requires a framework to be properly tested.
  -> Host Hunter uses testing frameworks to consistently reduce the risk of actions to a network. 
3. The ability to retrace the steps of a given series of events enables high quality action review and ensures users can prove / disprove their actions.
  -> Host Hunter ensures all actions are tracked once they leave the Base VM
  
## Legal Stuff
This is a project and released under the MIT licence. Use this at your own risk.

## Requirements
1. Base VM: Windows 10 (latest edition). Must also have .Net Core installed. 
2. Test Server: Windows Server 2016
3. Test Clients: Windows 10
4. Ubuntu 18.04 Server

## Setup
### Ubuntu 18.04 Server
1. Download latest Ubuntu 18.04 image. Website: http://releases.ubuntu.com/18.04/
2. Using your virtualisation option of choice (AWS/Azure/HomeLab/VMWare/Hyper-V) create Ubuntu 18.04 Server
    - Call the Ubuntu Server "HostHunterSIEM"
    - Choose Hard Disk wisely - this is where your host data will end up
    - todo: discuss how to integrate for distributed ops
3. Ensure SSH is working on Ubuntu Server
    - This can be selected during install 
    - If not selected during install: `sudo apt install openssh-server`
    - Run command `sudo systemctl status ssh`
4. Ensure server build is fully updated
    - `sudo apt update`
    - `sudo apt upgrade`
5. Get IP Address of server
    - `ifconfig`
6. Check that Powershell 6 can ssh to server
    - From Powershell 6 command prompt `ssh user@ipaddress`
    - Reboot server from Powershell `sudo reboot -f`
7. Once reboot is successful, shutdown server again and snapshot. Call it "Initial_Snapshot"

### Active Directory (AD) / Domain Controller (DC) / Domain Name Service (DNS)
1. Download Windows Server 2016 
    - I strongly recommend you use approved copies from the Microsoft Developers Network for this. 
2. Using your virtualisation option of choice (AWS/Azure/HomeLab/VMWare/Hyper-V) create the Windows Server 2016 Virtual Machine.
    - Call the Windows Server Host "HostHunter"
    - My personal preference for home labs is VMWare as it's easy to use. However it also costs $150 per year on average to maintain. Windows Professional now comes with Hyper-V for free, and Virtual Box is open source.
    - Standard settings are fine. This is the initial test lab, a series of updates, downloads and changes are about to take place.
    - Record the username and password you set for login. Ideally use the same for both, however up to you.
3. Take Snapshot (call it Initial_Snapshot)
4. On Remote Machine, enable Windows Remote Management.
    - Open Administrator powershell command prompt
    - Type command: `Invoke-PSRemoting -Force`
    - Update TrustedHosts Registry key `Set-Item WSMan:\localhost\client\trustedhosts *`
    - Note: *Setting trusted hosts to 'all hosts' is not recommended security practice. This will be modified through desired state configuration*
    - If an error is received about the network being public, perform the following commands:
        - Get Network Connection profile `Get-NetConnectionProfile`
        - Set the name of the network connection to private `Set-NetConnectionProfile -Name <name from step above> -NetworkCategory Private`
        - Note: *Setting the network category to private is an initial step, this will be resolved later*
    - Ensure WinRM receiving `winrm quickconfig`
        - Accept prompt 
5. Test WSMan is enabled on virtual machine by self-testing on VM.
    - `Test-WSMan -ComputerName localhost`
    - If no error returns, this now works
6. Take Snapshot (call it WSMan_Snapshot)

### Windows 10 Client
1. Download Windows 10 version you wish to use
    - I strongly recommend you use approved copies from the Microsoft Developers Network for this.
2. Using your virtualization option of choice, create the Windows 10 Virtual Machine
    - Call the Windows 10 Host "HostHunterClient"
    - Record the username and password you set for login. Ideally use the same for both, however up to you.
3. Take Snapshot (call it Initial_Snapshot)
4. On Remote Machine, enable Windows Remote Management.
    - Open Administrator powershell command prompt
    - Type command: `Invoke-PSRemoting -Force`
    - Update TrustedHosts Registry key `Set-Item WSMan:\localhost\client\trustedhosts *`
    - Note: *Setting trusted hosts to 'all hosts' is not recommended security practice. This will be modified through desired state configuration*
    - If an error is received about the network being public, perform the following commands:
        - Get Network Connection profile `Get-NetConnectionProfile`
        - Set the name of the network connection to private `Set-NetConnectionProfile -Name <name from step above> -NetworkCategory Private`
        - Note: *Setting the network category to private is an initial step, this will be resolved later* 
5. Test WSMan is enabled on virtual machine by self-testing on VM.
    - `Test-WSMan -ComputerName localhost`
    - If no error returns, this now works
6. Take Snapshot (call it WSMan_Snapshot)