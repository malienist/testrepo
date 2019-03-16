function Set-BaseVMFileStructure
{
    <#
	.Synopsis
    Uses Desired State Configuration (DSC) to setup base vm for operations.
    
	.Description
    Uses DSC to setup base vm opertions. Sets the following:
    1. File structure for use # todo: fill this out properly once finalised

	.Example
	Set-BaseVMFilestructure
    #>
    
    [CmdletBinding()]
	param
	(
        
    )

    Write-Information -InformationAction Continue -MessageData "Setting up Base VM filepaths"
    # Compile DSC script to generate MOF
    . .\SetupScripts\setfilepathsDSC.ps1
    # Create MOF file
    FilepathSetup
    # Set configuration
    Start-DscConfiguration FilepathSetup -Verbose -Wait -Force
    
    # Remove-Item -Path C:\Users\HostHunter\FilepathSetup -Recurse -Force -Verbose

}