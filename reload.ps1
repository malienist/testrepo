# Get settings
Write-Information -InformationAction Continue -MessageData "Getting settings"
$settings = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\settings.json | ConvertFrom-Json

# Setup global variables
$global:ExecuteableLocation = ($settings | Where-Object{$_.Type -match "ExecuteableLocation"}).FileLocation
$global:ModulePath = ($settings | Where-Object{$_.Type -match "ModuleList"}).FileLocation
$global:TestLabManifest = ($settings | Where-Object{$_.Type -match "TestLabManifest"}).FileLocation
$global:SettingsFile = "C:\Users\HostHunter\Manifests\settings.json"
$global:VirtualizationType = ($settings | Where-Object{$_.Type -match "VirtualizationType"}).Vendor
$global:WindowsServerTemplate = ($settings | Where-Object{$_.Type -match "WindowsServerTemplate"}).Setting
# Import modules
$message = $ModulePath
Write-Host $message
$modules = Get-Content -Raw -Path $ModulePath | ConvertFrom-Json
foreach($line in $modules){
    $ImportString = "Importing: " + $line.Name
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line.FileLocation -Force
}

