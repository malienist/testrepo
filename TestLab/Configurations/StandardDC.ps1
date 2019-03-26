Configuration NewDomain
{
    Import-DscResource -ModuleName xActiveDirectory
    Import-DscResource -ModuleName 'PSDesiredStateConfiguration'
    
    # Set the Domain Name
    Node $DomainName
    {
        # Ensure reboots will happen automatically and continue install
        LocalConfigurationManager
        {
            ActionAfterReboot = 'ContinueConfiguration'
            RebootNodeIfNeeded = $true
            ConfigurationMode = 'ApplyOnly'
        }

        # Setup NTDS
        File ADFiles
        {
            DestinationPath = 'N:\NTDS'
            Type = 'Directory'
            Ensure = 'Present'
        }
        
        # Install ADDS features
        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
        }
        
        # Combine it all
        xADDomain FirstDS
        {
            DomainName = $DomainName
            DomainAdministratorCredential = $domainCred
            SafeModeAdministratorPassword = $safemodeAdministratorCred
            DatabasePath = 'N:\NTDS'
            LogPath = 'N:\NTDS'
            DependsOn = "[WindowsFeature]ADDSInstall", "[File]ADFiles"
        }
    }
}