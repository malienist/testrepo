function Set-BaseVMCoreExecuteables{
	<#
	.Synopsis
    Installs the core executeables for Base VM using DSC
    
	.Description
    Installs the following core executeables for Base VM:
    1. Python 3
    # todo: keep updated
    
	.Example
	Set-BaseVMCoreExecuteables

	#>

	[CmdletBinding()]
	param
	(
        
    )
	
	Write-Information -InformationAction Continue -MessageData "Setting up core executeables"
	# Compile DSC script to generate MOF
	. .\SetupScripts\installcoreexesDSC.ps1
	# Create MOF File
	CoreExecuteables
	# Set Configuration
	Start-DscConfiguration CoreExecuteables -Verbose -Wait -Force
	
	Remove-Item -Path C:\Users\HostHunter\CoreExecuteables -Recurse -Force -Verbose
	
	# Now setup the executeables that don't require installation
	Write-Information -InformationAction Continue -MessageData "Setting up executeables which don't require install"
	# vscode
	Open-ZipFile -ZipFile C:\Users\HostHunter\Executeables\vscode_x64.zip -ExtractionLoc C:\Users\HostHunter\Executeables\vscode_x64
	
}