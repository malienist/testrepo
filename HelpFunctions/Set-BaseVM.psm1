function Set-BaseVM
{
    <#
	.Synopsis
    Uses Desired State Configuration (DSC) to setup base vm for operations.
    
	.Description
    Uses DSC to setup base vm opertions. Sets the following:
    1. File structure for use

	.Example
	Set-BaseVM
    #>
    
    [CmdletBinding()]
	param
	(
        
    )

    # Compile DSC script to generate MOF
    . .\basevmscript.ps1
    # Create MOF file
    HostVMSetup
    # Set configuration
    Start-DscConfiguration .\HostVMSetup -Verbose -Wait

}