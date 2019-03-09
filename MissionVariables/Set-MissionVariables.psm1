function Set-MissionVariables{
	<#
	.Synopsis
    Sets the global mission variables for the framework to use.
    
	.Description
	Sets / changes the global mission variables for the framework to use

	.Example
	Set-MissionVariables
	Creates a new target, set as 192.168.1.23

    #>
    [CmdletBinding()]
	param
	(
		[switch]$NewMission
    )
    
    # If new mission, clear out old data and reset
    if($NewMission){
        # Set Mission Name
        $global:MissionName = Read-Host "Mission Name"

        $clearprevious = Read-Host "Clear previous data?(y/n)"

        if($clearprevious -eq "y"){
            # Now delete all settings. Relevant because of the extensive use of git.
            foreach($file in $clearancelist){
                # Test to see if previous file exists
                $path = Test-Path $file
                if($path -eq $true){
                    Remove-Item -Path $file
                    $info = $file + ": Removed"
                    Write-Information -InformationAction Continue -MessageData $info
                }else{
                    $info = $file + ": Not Present"
                    Write-Information -InformationAction Continue -MessageData $info
                }
            }
        }
        
        # Now setup all the variables for splunk etc
        $global:SplunkIP = Read-Host "Splunk IP/Hostname"
        $global:AccountabilityPort = Read-Host "Accountability Port"
        $global:SplunkPort = Read-Host "Splunk Port"

        # Setup Domain Controller
        # Set Domain Controller Address
        $DomainControllerIP = Read-Host "Domain Controller IP"
        $DomainControllerHostName = Read-Host "Domain Controller HostName"
        Add-DomainController -IP $DomainControllerIP -HostName $DomainControllerHostName

    }else{
        $settings = Get-Content -Raw -Path $settingslistloc
        $SplunkIP = $settings.SplunkIP
        $AccountabilityPort = $settings.AccountabilityPort
        $SplunkPort = $settings.SplunkPort
        $MissionName = $settings.MissionName
    }
    

    $MissionVariables = @{
        "Object" = "MissionSettings"
        "SplunkIP" = $SplunkIP
        "AccountabilityPort" = $AccountabilityPort
        "SplunkPort" = $SplunkPort
        "MissionName" = $MissionName
    }

    # Check to make sure an old version of the settings has not been used. Especially because git is used extensively.
    $settingsjson = $MissionSettings | ConvertTo-Json
    $settingsjson | Out-File $settingslistloc

    Write-Output $MissionVariables

}