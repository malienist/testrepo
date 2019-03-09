function New-Executable
{
    <#
	.Synopsis
    Adds a new executable to the download list for inclusion into the HostHunter framework
    
	.Description
    Adds a new executable to the download list for inclusion into the HostHunter framework.
    Modifies the executablemanifest.json file

	.Example
	New-Executable
    #>
    
    # todo: turn these params into full params - declare type of var expected, include mandatory
    [CmdletBinding()]
	param
	(
        $ExeName,
        $ExeSha256Hash,
        $ExeMD5Hash,
        $ExeSha2Hash,
        $ExeURL
    )

    # Get executable manifest
    $exemanifestjson = Get-Content C:\Users\HostHunter\modulemanifest.json

    # Convert into powershell objects
    $exemanifest = ConvertFrom-Json $exemanifest
    # Assume not true initially
    $noexe = $true
    # Check that the current suggested executable doesn't already exist. Check name, url and hash
    foreach($exe in $exemanifestjson)
    {
        if($exe.ExeName -eq $ExeName -and $exe.Sha256Hash -eq $ExeSha256Hash -and $exe.URL -eq $ExeURL)
        {
            Write-Information -MessageData "Executable already in framework"
            $noexe = $false
        }
    }
    if($noexe -eq $true)
    {
        # Add executable to the list
        $newexe = @{
            ExeName = $ExeName
            Sha256Hash = $ExeSha256Hash
            MD5Hash = $ExeMD5Hash
            Sha2Hash = $ExeSha256Hash
            URL = $ExeURL
        }
        # Add to array
        $exemanifest += $newexe
    }
    # Write updated list of exes back to disk
    $exeoutput = $exemanifest | ConvertTo-Json
    $exeoutput | Out-File -FilePath "C:\Users\HostHunter\modulemanifest.json"

}