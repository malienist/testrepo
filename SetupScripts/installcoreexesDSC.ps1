# Installs core executeables on Base VM if they are not already present
# https://www.petri.com/deploying-software-using-desired-state-configuration

Configuration CoreExecuteables
{
    # If DSC not already downloaded, download now
    Import-DscResource -ModuleName PsDesiredStateConfiguration
    
    # Configuration happens on this machine, i.e. LocalHost
    Node 'localhost'
    {
        Package Python3
        {
            # Note MSI installer not available for releases past 3.4 at this stage.
            # https://docs.python.org/3/using/windows.html
            Name = "python_3.7.2.exe" # todo: make this dynamic with download file
            Path = "C:\Users\HostHunter\Executeables\python_3.7.2.exe" # todo: update module manifest with download location and whether it's core or not
            Ensure = "Present"
            ProductId = ""
            Arguments = "/passive"
        }
        Package Python2
        {
            Name = 'Python 2.7.16 (64-bit)'
            Path = "C:\Users\HostHunter\Executeables\python_2.7.16.msi"
            Ensure = "Present"
            ProductId = "DCD5B320-89D9-4C7C-9E8B-84496588744E"
        }
    }
}