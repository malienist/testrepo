# Get settings
Write-Information -InformationAction Continue -MessageData "Getting settings"
$settings = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\settings.json | ConvertFrom-Json

# Setup global variables
$global:ExecuteableLocation = ($settings | Where-Object{$_.Type -match "ExecuteableLocation"}).FileLocation
$global:ModulePath = ($settings | Where-Object{$_.Type -match "ModuleList"}).FileLocation

# Import modules
$message = $ModulePath
Write-Host $message
$modules = Get-Content -Raw -Path $ModulePath | ConvertFrom-Json
foreach($line in $modules){
    $ImportString = "Importing: " + $line.Name
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line.FileLocation -Force
}

