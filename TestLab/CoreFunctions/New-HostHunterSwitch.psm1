function New-HostHunterSwitch{
	<#
	.Synopsis
    Sets up a virtual switch for TestLab specific to HostHunter Framework.
    
	.Description
    Sets up a virtual switch for TestLab specific to HostHunter Framework
    
	.Example
	New-HostHunterSwitch
	
	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][String][ValidateSet('External','Internal','Private')]$SwitchType,
		[String]$Name
    )
	
	if(-not $Name)
	{
		$Name = "HostHunterSwitch" + $SwitchType
	}
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		VirtualizationType = $VirtualizationType
		VirtualSwitchType = $SwitchType
		VirtualSwitchName = $Name
		Outcome = "false"
	}
	
	if($VirtualizationType -eq "HyperV")
	{
		
		$output.Outcome = $switch.Outcome
		Get-NetAdapter
		$netadapter = Get-NetAdapter
		$whichadapter = Read-Host "Type string for Net-Adapter selected (i.e. Ethernet 7)"
		if($netadapter | Where-Object {$_.Name -eq $whichadapter})
		{
			$switch = New-HyperVHostHunterSwitch -SwitchType $SwitchType -Name $Name -NetworkAdapter $whichadapter
			$output.Outcome = $switch.Outcome
		}else{
			Write-Information -InformationAction Continue -MessageData "No VM Adapter of this name. Try again"
			$output.Outcome = "False"
			break
		}
	}
	
	# Write output to pipeline
	Write-Output $output

}