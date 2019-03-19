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

## Setup
### Active Directory (AD) / Domain Controller (DC) / Domain Name Service (DNS)
1. Download Windows Server 2016
  -> I strongly recommend you use approved copies from the Microsoft Developers Network for this. 
2. Using your virtualisation option of choice (AWS/Azure/HomeLab/VMWare/Hyper-V) create the Windows Server 2016 Virtual Machine.
  -> My personal preference for home labs is VMWare as it's easy to use. However it also costs $150 per year on average to maintain. Windows Professional now comes with Hyper-V for free, and Virtual Box is open source.
  -> Standard settings are fine. This is the initial test lab, a series of updates, downloads and changes are about to take place.
3. Take Snapshot (call it Initial_Snapshot)
4. On Remote Machine, enable Windows Remote Management. 
  -> In administrator Powershell window "Enable-PSRemoting -Force"
  -> Change Trusted Hosts registry key to * (all hosts) "Set-Item WSMan:\localhost\client\trustedhosts *" :Note - this allows all hosts which can authenticate to your machine to remote in. This is NOT ideal, and is only to be used for the initial configuration.*
5. Test that WSMan works on local machine. "Test-WSMan -ComputerName localhost"
  -> If no error returns, this now works.
6. Take Snapshot (call it WSMan_Snapshot)
7. Update Machine from Base VM
  -> 

