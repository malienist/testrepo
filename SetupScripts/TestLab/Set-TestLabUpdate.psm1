function Set-TestLabUpdate{
	<#
	.Synopsis
    Gets and installs updates in the test lab.
    
	.Description
    Gets updates for the test lab and then installs them.
    
    .Parameter
    Target - the endpoint being targeted for the update

	.Example
	Set-TestLabUpdate


	#>

	[CmdletBinding()]
	param
	(
		$Target
    )
	
	$output = @{
		Target = $Target
	}
	
	$message = "Updating target: $Target"
	Write-Information -InformationAction Continue -MessageData $message
	

}