# Script to setup base VM

# Information on DSC can be found here: https://docs.microsoft.com/en-us/powershell/dsc/overview/overview

# todo: download a 'todo' extension

Configuration FilepathSetup{
    # Import the module that contains the File Resource
    Import-DSCResource -ModuleName PsDesiredStateConfiguration

    Node 'localhost'{
        # Base of file structure
        File HostHunter{
            DestinationPath = "C:\Users\HostHunter"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of all executables
        File Executables{
            DestinationPath = "C:\Users\HostHunter\Executables"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of all Gather Powershell modules
        File Gather{
            DestinationPath = "C:\Users\HostHunter\Gather"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of all Interact Powershell modules
        File Interact{
            DestinationPath = "C:\Users\HostHunter\Interact"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of all Help Powershell modules
        File HelpFunctions{
            DestinationPath = "C:\Users\HostHunter\HelpFunctions"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of all manifests
        File Manifests{
            DestinationPath = "C:\Users\HostHunter\Manifests"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of development files and help functions
        File Development{
            DestinationPath = "C:\Users\HostHunter\Development"
            Ensure = "Present"
            Type = "Directory"
        }
        # Location of databasing tools
        File Databasing{
            DestinationPath = "C:\Users\HostHunter\Databasing"
            Ensure = "Present"
            Type = "Directory"
        }
    } 
}