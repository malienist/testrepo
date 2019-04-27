function Set-VirtualizationPreference{
    <#
	.Synopsis
    Sets the virtualization preference for test lab. Downloads appropriate modules and updates settings file.
    
	.Description
    Sets the virtualization preference for test lab. Downloads appropriate modules and updates settings file.
    
	.Parameter
	VirtualizationPreference

	.Example
	Set-VirtualizationPreference -VirtualizationPreference VMWare

	#>

    [CmdletBinding()]
    param
    (
        [parameter(Mandatory=$true)][ValidateSet('HyperV')][string]$VirtualizationPreference
    )

    $output = @{
        "Virtualization" = $VirtualizationPreference
        "Version" = ""
        "Outcome" = "Failed"
    }
    
    # Confirm modules for chosen virtualization preference are installed
    if($VirtualizationPreference -eq "VMWareWorkstation")
    {
        Write-Information -InformationAction Continue -MessageData "VMware chosen for Virtualization"
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
                Set-Setting -Type "VirtualizationPreference" -Version $version -Vendor "VMWare" 
                
            }else{
                Write-Information -InformationAction Continue -MessageData "VMWToolkit installation failed"
            }
        }
    }
    elseif($VirtualizationPreference -eq "HyperV")
    {
        Write-Information -InformationAction Continue -MessageData "HyperV standard installation available"
        $version = ""
        Set-Setting -Type $VirtualizationPreference -Version $version -Vendor "HyperV"
        Write-Information -InformationAction Continue -MessageData "Installing Hyper-V Powershell modules and features"
        powershell Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-Tools-All
    }
    
}