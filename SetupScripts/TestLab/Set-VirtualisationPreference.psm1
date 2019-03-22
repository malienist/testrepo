function Set-VirtualisationPreference{
    <#
	.Synopsis
    Sets the virtualisation preference for test lab. Downloads appropriate modules and updates settings file.
    
	.Description
    Sets the virtualisation preference for test lab. Downloads appropriate modules and updates settings file.
    
	.Parameter
	VirtualisationPreference

	.Example
	Set-VirtualisationPreference -VirtualisationPreference VMWare

	#>

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)][ValidateSet('VMwareWorkstation', 'HyperV')][string]$VirtualisationPreference
    )

    $output = @{
        "Virtualisation" = $VirtualisationPreference
        "Version" = ""
        "Outcome" = "Failed"
    }
    
    # Confirm modules for chosen virtualisation preference are installed
    if($VirtualisationPreference -eq "VMWareWorkstation")
    {
        Write-Information -InformationAction Continue -MessageData "VMware chosen for Virtualisation"
        if(Get-Module -Name vmxtoolkit)
        {
            Write-Information -InformationAction Continue -MessageData "VMX Toolkit installed"
        }else{
            # Download vmxtoolkit
            Install-Module vmxtoolkit
            # Check again
            if(Get-Module -Name vmxtoolkit)
            {
                Write-Information -InformationAction Continue -MessageData "VMX Toolkit installed"
                $output.Outcome = "Success"
                # Get version of vmware installed
                $version = (Get-VMwareVersion).Major
                
                # Update settings file
                Set-Setting -Type $VirtualisationPreference -Version $version -Vendor "VMWare" 
                
            }else{
                Write-Information -InformationAction Continue -MessageData "VMWToolkit installation failed"
            }
        }
    }
    
}