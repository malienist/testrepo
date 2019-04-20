function New-HyperVHostHunterSwitch{
	<#
	.Synopsis
    Sets up a new Virtual Switch through HyperV Powershell console.
    
	.Description
    Sets up a new Virtual Switch through HyperV Powershell console.
    Uses this website heavily: https://docs.microsoft.com/en-us/windows-server/virtualization/hyper-v/get-started/create-a-virtual-switch-for-hyper-v-virtual-machines
    
	.Parameter
	Testing - switch for if this is a test switch
	
	.Parameter
	SwitchType - the type of switch being created

	.Example
	New-HyperVHostHunterSwitch

	#>

	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true)][String][ValidateSet('External','Internal','Private')]$SwitchType,
		[Parameter(Mandatory=$true)][String]$NetworkAdapter,
		[String]$Name="HostHunterSwitch"
    )
	
	#Ensure different types of switch clearly denoted
	$name = $Name + $SwitchType
	
	# Create custom powershell object for output
	$output = [PSCustomObject]@{
		SwitchType = $SwitchType
		SwitchName = $Name
		Outcome = "false"
		SwitchDetails = @{}
	}
	
	$switch = Get-VMSwitch | Where-Object {$_.ItemName -eq $Name}
	
	# Check if switch already exists
	if($switch)
	{
		$switch 
		$message = "$Name virtual switch already exists"
		Write-Information -InformationAction Continue -MessageData $message
		$output.Outcome = "true"
	}else{
		if($SwitchType -eq "External")
		{
		$switch = New-VMSwitch -Name $Name -NetAdapterName $NetworkAdapter -AllowManagementOS $true
			
		}
		elseif($SwitchType -eq "Internal")
		{
			$switch = New-VMSwitch -Name $Name -SwitchType Internal
		}
		elseif($SwitchType -eq "Private")
		{
			$switch = New-VMSwitch -Name $Name -SwitchType Private
		}
	}

	$output.SwitchDetails = $switch
	
	# Check switch now exists
	if(Get-VMSwitch | Where-Object {$_.Name -eq $Name})
	{
		$output.Outcome = "True"
	}else{
		$output.Outcome = "False"
	}
	
	# Write output to pipeline
	Write-Output $output

}