function Invoke-InitialWinRMFileTransfer{
	<#
	.Synopsis
	File transfer function. Copies a target file and tranfers it directly across the network. No encryption or compression.

	.Description
	Simplest possible file transfer function. Copies a file from the local machine and tranfers it across to the target machine. 
	Uses WinRM as the tranfer protocol, which means file size is limited.

	.Parameter
	TargetFilePath - file path on the target machine to store file
	
	.Parameter
	LocalFilePath - file on local machine where file is stored

	.Example
	Invoke-WinRMFileTransfer -TargetFilePath 'C:\Users\LikeABoss.awe' -LocalFilePath 'C:\MyFile\ToTransfer.ps1'
	#>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$TargetFilePath,
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$LocalFilePath,
		[Parameter(Mandatory=$true, ValueFromPipeline=$true)][string]$ComputerName
	)

	# Due to complexity of interfacing this with Invoke-HostCommand, recreate all logical accountability functionality
	# within this command. This will require extra testing.
	# Create Command ID. Random number plus date.
	$CommandID = Get-Random
	$CommandID = $CommandID.ToString()
	$hasher = New-Object System.Security.Cryptography.SHA256Managed
	$tohash = [System.Text.Encoding]::UTF8.GetBytes($CommandID)
	$hashByteArray = $hasher.ComputeHash($tohash)
	foreach($byte in $hashByteArray)
	{
		$CommandIDHash += $byte.toString()
	}

	# Get hash of binary 
	$hash = Get-FileHash -Algorithm SHA256 -Path $LocalFilePath
	$hash = $hash.Hash

	$initialObject = @{
		"CommandID" = $CommandIDHash
		"Operator" = "Penny"
		"TargetIP" = $Target
		"TargetHostname" = $Target
		"SimpleCommand" = ""
		"CommandHash" = $hash
		"TimeExecuted" = Get-Date
		"EffectiveID" = ""
		"SystemMethod" = "None"
	}

	$CommandObject = New-Object -TypeName psobject -Property $initialObject
	$CommandObject = $CommandObject | ConvertTo-Json | Out-String
	$CommandObject | ConvertTo-Json | Out-File -FilePath C:\Users\HostHunter\Manifests\StoredLogicalAccountability\LogicalAccountability.json

	$file = $LocalFilePath
	$content = [System.IO.File]::ReadAllBytes($file)
	$filetransfer = Invoke-Command -ComputerName $ComputerName -Credential (Get-Credential -Message "Enter local credential for target") -Scriptblock{
		#transfer the file across to target machine 
		[System.IO.File]::WriteAllBytes($args[0], $using:content)
		#check file has landed
		$filesuccess = Test-Path $args[0]
		if($filesuccess -eq $true){
			$filesuccess = "Success"
		}
		$HostName = $env:COMPUTERNAME
		$filepass = @{
			"Object"= "WinRMFileTransfer"
			"Outcome" = $filesuccess
			"FileName" = $args[0]
			"Time" = Get-Date
			"FileHash" = $hash.Hash
			"HostName" = $HostName
		}
		Write-Output $filepass
	} -ArgumentList $TargetFilePath

	# Add in unique identifier to filetransfer object so it can always be tracked
	$filetransfer | Add-Member -NotePropertyName CommandID -NotePropertyValue $initialObject.CommandID
	$filetransfer | Add-Member -NotePropertyName TargetFilePath -NotePropertyValue $TargetFilePath
	$filetransferoutput = $filetransfer
	$filetransfer = $filetransfer | ConvertTo-Json | Out-String
	

	Write-Output $filetransferoutput
}