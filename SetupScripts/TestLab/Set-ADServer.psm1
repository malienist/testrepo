function Set-ADServer{
	<#
	.Synopsis
    Sets up the AD Server for the Test Lab
    
	.Description
    Sets up the following components for the test lab on the AD:
    1. Ensures 2019 Server fully updated
    2. Ensures AD role enabled
    3. Ensures Windows Remote Management enabled
    4. Creates the domain
    5. Creates two domain admin users
    6. Creates two normal users
    7. Stores names and passwords in a text file on Base VM

	.Example
	Set-ADServer

	#>

	[CmdletBinding()]
	param
	(
        [switch]$Home,
		[switch]$WindowsBased
    )

	Write-Information -InformationAction Continue -MessageData "Setting up testing infrastructure"
}