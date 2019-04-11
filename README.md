# HostHunterCore
Powerful Windows Management Framework Core endpoint hunting framework.

Build with Powershell, Python 2/3, C#, C/C++, Ansible and DSC, the Host Hunter framework empowers users to implement Hypothesis Driven hunting on their Defended Networks. The framework ensures minimal artifacts, strong accountability and tighly controlled information types. All tactics and techniques hunted for are based upon open source research.

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
### Overview
The initial setup of HostHunter achieves several outcomes for the user:
1. Builds a test lab
2. Sets up Base VM 
3. Loads framework and required executables onto Base VM
4. Runs a series of tests to ensure framework functioning as desired

### Test Lab
#### Outcomes
1. Download base ISO images
2. Create template VMs in user selected virtualization option of choice
3. Build standard network - https://www.draw.io/#G1wbakEl_m6Mcddblre387veJa-OgE1aBs

### Required ISOs
Download the ISOs below to the downloads folder:
1. Windows Server 2016
2. Windows 10 Enterprise
3. Ubuntu 18.04 Live Server http://releases.ubuntu.com/18.04/

### Process
1. Ensure your virtualization option of choice is ready for use (note for this version of HostHunter, only HyperV is supported)
2. Once ISOs are downloaded, open an Administrator Powershell 6/7 shell
3. Navigate to HostHunter download
4. Run `setup.ps1`
5. Follow prompts

### Expected results
