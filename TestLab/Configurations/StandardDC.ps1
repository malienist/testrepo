# Many thanks to https://blogs.technet.microsoft.com/ashleymcglone/2015/03/20/deploy-active-directory-with-powershell-dsc-a-k-a-dsc-promo/

configuration NewDomain
{
    param
    (
        [Parameter(Mandatory)]$DomainName,
        [Parameter(Mandatory)][pscredential]$domainCred,
        [Parameter(Mandatory)][pscredential]$safemodeAdministratorCred
    )
    
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