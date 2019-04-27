function Invoke-HostHunterSetup{
	<#
	.Synopsis
    Overarching setup module for HostHunter and TestLab. 
    
	.Description
    Overarching setup module for HostHunter and TestLab. Designed to be as automated as possible. 
    
	.Parameter
	[switch]NotUpdateHelp - if selected, stops setup from updating PowershellHelp. Used to save time.
	
	.Parameter
	[switch]NotFileSetup - if selected, stops setup from setting up FilePath. Used to save time.
	
	.Parameter
	[switch]NotTestLab - if selected, stops setup from setting up TestLab. Used to save time.
	
	.Parameter
	[switch]NotFramework - if selected, stops setup from setting up HostHunter Framework. Used to save time

	.Example
	Invoke-HostHunterSetup

	#>

	[CmdletBinding()]
	param
	(
        [string]$NotUpdateHelp,
		[string]$NotFileSetup,
		[string]$NotTestLab,
		[string]$NotFramework
    )
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		Outcome = "Failed"
		PowershellHelp = "NotUpdated"
		FileStructure = "NotUpdated"
		TestLab = "NotInstalled"
		Framework = "NotInstalled"
	}
	
	# Confirm WinRM working
	$winrm = Test-WSMan -ComputerName localhost
	if(-not $winrm)
	{
		while($winrm.Outcome -ne "Success")
		{
			$winrm = Initialize-HHWinRM
		}
	}
	
	# Update Powershell help if required
	if(-not $NotUpdateHelp)
	{
		# Update Powershell Help
		Write-Information -InformationAction Continue -MessageData "Updating Help"
		Update-Help
		$output.PowershellHelp = "Updated"
	}
	
	# Construct File Paths and change Access Control Lists (ACLs) if required
	if(-not $NotFileSetup)
	{
		# Import DSC module
		Write-Information -InformationAction Continue -MessageData "Configuring Base VM"
		Import-Module C:\Users\HostHunter\SetupScripts\Set-BaseVMFileStructure.psm1 -Force
		# Now configure BaseVM
		Set-BaseVMFileStructure

		# Now change the permissions on this folder and all subfolders so that user (i.e. me) can freely 
		# access and save it. Many thanks to this website: https://blogs.msdn.microsoft.com/johan/2008/10/01/powershell-editing-permissions-on-a-file-or-folder/
		# and https://stackoverflow.com/questions/33234047/powershell-how-to-give-full-access-a-list-of-local-user-for-folders
		# Microsoft documentation page: https://docs.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.filesystemaccessrule?view=netframework-4.7.2

		Write-Information -InformationAction Continue -MessageData "Updating Folder Permissions"
		$ACL = Get-Acl -Path C:\Users\HostHunter
		$NewACL = New-Object System.Security.AccessControl.FileSystemAccessRule($env:USERNAME, "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
		Set-ACL -Path C:\Users\HostHunter\ $ACL
	}
	
	# Import all modules into current shell
	Write-Information -InformationAction Continue -MessageData "Importing powershell modules"
	.\reload.ps1
	
	# Set Virutalization Preference
	Write-Information -InformationAction Continue -MessageData "########################################"
	$virtualization = ""
	while($virtualization -ne "HyperV")
	{
		$virtualization = Read-Host "Set virtualisation preference (Currently only HyperV available) (HyperV)"
	}
	
	Set-VirtualizationPreference -VirtualizationPreference $virtualization
	
	#############################################################
	####################### TestLab Setup #######################
	#############################################################
	
	if(-not $NotTestLab)
	{
		Write-Information -InformationAction Continue -MessageData "#############################################################"
		$message = "Initializing TestLab using $virtualization"
		Write-Information -InformationAction Continue -MessageData "Initializing TestLab using $virtualization"
		Write-Information -InformationAction Continue -MessageData "#############################################################"
		
		
	}
	
	# Write output to pipeline
	Write-Output $output

}