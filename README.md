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

### Template Creation Process
1. Ensure your virtualization option of choice is ready for use (note for this version of HostHunter, only HyperV is supported)
2. Once ISOs are downloaded, open an Administrator Powershell 6/7 shell
3. Navigate to HostHunter download
4. Run `setup.ps1`
5. Provide prompts with filenames, hashes and hash types for the previously stored ISOs
6. For VM Template creation:
    - Ubuntu 18.04 Settings:
        - Follow standard prompts
        - If proxy required, setup (not covered in this guide)
        - Record the IP Address stated during setup
        - Select the name you desire. Call the Server: ubuntu1804server_template. Make sure you record the username:password
        - Install OpenSSH server
        - Choose the packages you wish to install. I recommend no extras, but up to you.
        - Ignore the prompt: "Please remove the installation medium, then press ENTER:". This occurs automatically through `Build-TestLabTemplates` module
        - When completed installation completed, login to server using credentials
        - Run the following commands to install Microsoft Linux Integration Services (LIS):
            - Edit modules file in initramfs-tools: 
                - `sudo nano /etc/initramfs-tools/modules`
                - Add the following lines at the bottom:
                    - `hv_vmbus`
                    - `hv_storvsc`
                    - `hv_blkvsc`
                    - `hv_netvsc`
            -Reinitialize modules file:
                - `sudo apt install linux-virtual linux-cloud-tools-virtual linux-tools-virtual`
                - `update-initramfs -u`
            - Reboot Machine
            - Credit to https://oitibs.com/hyper-v-lis-on-ubuntu-18-04/
        - Install python2 integrator for use with ansible
            - `sudo apt install python-minimal python-simplejson`
            - Many thanks to https://github.com/ansible/ansible/issues/46980
        - Return to Powershell prompt and press enter to continue
    - Windows 10 Enterprise Settings:
        - Follow standard prompts
        - For "Let's connect you to a network" select either 'Domain Join' or 'Skip for Now'
        - Record username:password combination
        - (recommended) turn off Cortana and all tracking
        - When Windows starts up, return to Powershell prompt and press enter to continue
    - Windows Server 2016
        - Follow prompts
        - (recommended) Select 'Windows Server 2016 Datacenter (Desktop Experience)'
        - Record username:password
        - When Windows starts up, return to Powershell prompt and press enter to continue
        
### HostHunter Core Services Setup Process
#### Ansible Server
Used to maintain configuration control of test networks, simplifying the ability to install new configuration managed items for testing purposes
1. Choose whether to install a local ansible or server, or use your organizations master ansible server. If a master server selected, simply enter in the IP and Hostname.
##### Master Server
2. Enter IP address
3. Enter Hostname
4. Continue
##### Local Server
2. At prompt, enter username from Ubuntu Server template creation
3. At ssh prompt, enter the following commands:
    - `sudo apt update`
    - `sudo apt install software-properties-common`
    - `sudo apt-add-repository --yes --update ppa:ansible/ansible`
    - `sudo apt install ansible`
    - If during this process you get an error regarding another process using apt, follow this website to resolve: https://itsfoss.com/could-not-get-lock-error/
    - Generate ssh keys for future use configuring items: `ssh-keygen` 
        - Follow standard prompts
        - Changing the default file location is not supported at this stage
    - Create an ansible user to interact with ansible files
        - `sudo adduser ansible`
        - If you want more information / details about this, checkout https://linuxize.com/post/how-to-create-a-sudo-user-on-ubuntu/
    - Give permission to the username you are using to add / modify ansible files
        - `sudo chown -R <username> /etc/ansible/`
4. Once install completed, exit ssh session:
    - `exit`
