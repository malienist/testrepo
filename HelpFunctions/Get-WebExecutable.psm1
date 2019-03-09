function Get-WebExecutable{
	<#
	.Synopsis
    Downloads executable from website in a safe manner
    
	.Description
	Downloads executable from website in a safe manner. Uses System.Net.WebClient
	Code developed from: https://learn-powershell.net/2011/02/11/using-powershell-to-query-web-site-information/
    
	.Parameter
	URL - The URL to download from

	.Example
	Get-WebExecutable -URL https://fastdl.mongodb.org/win32/mongodb-win32-x86_64-2008plus-ssl-4.0.6-signed.msi

	#>

	[CmdletBinding()]
	param
	(
		[string]$URL,
		[string]$Outfile,
		[string]$Hash
    )

	# todo: Ensure file gets hashed after download
	# Ensure correct verions of TLS/SSL in use
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
	$web = New-Object System.Net.WebClient
	$flag = $false
<<<<<<< HEAD

	# Download URL to specified outfile
=======
>>>>>>> 1daeefe1701a361f40a3a30f5525b917f345c2d2
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
<<<<<<< HEAD

	# Now download has finished, confirm file exists
	$filetest = Test-Path -Path $outfile
	if($filetest -eq "True"){
		$output = @{
			FileExists = "True"
			FilePath = $Outfile
		}
	}

	Write-Output $filetest

=======
>>>>>>> 1daeefe1701a361f40a3a30f5525b917f345c2d2
}