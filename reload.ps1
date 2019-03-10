# Import all modules into current command shell
Write-Information -MessageData "Importing powershell modules"
$modules = Get-Content C:\Users\HostHunter\Manifests\modulemanifest.txt
foreach($line in $modules){
    $ImportString = "Importing: " + $line.tostring()
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line -Force
}