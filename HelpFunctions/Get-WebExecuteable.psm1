function Get-WebExecuteable{
	<#
	.Synopsis
    Downloads executable from website in a safe manner
    
	.Description
	Downloads executable from website in a safe manner. Uses System.Net.WebClient
	Code developed from: https://learn-powershell.net/2011/02/11/using-powershell-to-query-web-site-information/
	For BITS http://woshub.com/copying-large-files-using-bits-and-powershell/
	
	.Parameter
	URL - The URL to download from

	.Parameter
	Outfile - the location to store the output from the download

	.Parameter
	Hash - the file hash of the downloaded file

	.Parameter
	BITS - switch to use if a large file requiring feedback to user to be used

	.Parameter
	Async - switch to use if file is being transfered asynchronously

	.Example
	Get-WebExecutable -URL https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.6-signed.msi

	#>

	[CmdletBinding()]
	param
	(
		[string]$URL,
		[string]$Outfile,
		[string]$Hash,
		[switch]$BITS,
		[switch]$Async
    )

	# todo: Ensure file gets hashed after download
	# Ensure correct verions of TLS/SSL in use
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$web = New-Object System.Net.WebClient
	$flag = $false

	# Download URL to specified outfile
	if($BITS)
	{
		$notification = "Starting BITS transfer of $URL"
		Write-Information -InformationAction Continue -MessageData $notification
		if($Async){
			Start-BitsTransfer -Source $URL -Destination $Outfile -Asynchronous 
		}else{
			Start-BitsTransfer -Source $URL -Destination $Outfile
		}
	}else{
		While ($flag -eq $false)
		{
			Try
			{
				$URL = $URL.ToString()
				$web.DownloadFile($URL, $Outfile)
				$flag = $true
			}Catch{
				$output = "Download of $URL unsuccessful, retrying"
				Write-Information -InformationAction Continue -MessageData $output
			}
		}
	}
	

	# Now download has finished, confirm file exists
	$filetest = Test-Path -Path $outfile
	if($filetest -eq "True"){
		$output = @{
			"FileExists" = "True"
			"FilePath" = $Outfile
		}
	}

	Write-Output $output

}