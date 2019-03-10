function Open-ZipFile{
	<#
	.Synopsis
    Extracts a zip file to specified location
    
	.Description
	Uses System.IO.Compression.FileSystem to unzip specified file
	https://docs.microsoft.com/en-us/dotnet/standard/io/how-to-compress-and-extract-files
    
	.Parameter
	ZipFile - File to be unzipped

	.Parameter
	ExtractionLoc - Location for file to be unzipped to

	.Example
	Open-ZipFile -ZipFile C:\Users\HostHunter\Executables\sqlite.zip -ExtractionLoc C:\Users\HostHunter\Executables\

	#>

	[CmdletBinding()]
	param
	(
		[string]$ZipFile,
		[string]$ExtractionLoc
	)
	
	Add-Type -AssemblyName System.IO.Compression.FileSystem
	[System.IO.Compression.ZipFile]::ExtractToDirectory($Zipfile, $ExtractionLoc)
	$message = "File extracted to: $ExtractionLoc"
	Write-Information -InformationAction Continue -MessageData $message

}