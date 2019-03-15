# Import all modules into current command shell
Write-Information -MessageData "Importing powershell modules"
$settings = Get-Content -Raw -Path C:\Users\HostHunter\Manifests\settings.json | ConvertFrom-Json
foreach($setting in $settings)
{
    if($setting.Type -eq "ExecuteableLocation")
    {
        $ExecuteableLocation = $settings.FileLocation
    }
    elseif ($setting.Type -eq "FileLocation")
    {
        $ModulePath = $setting.FileLocation
    }
}
$modules = Get-Content -Raw -Path $modulepath | ConvertFrom-Json
foreach($line in $modules){
    $ImportString = "Importing: " + $line.Name
    Write-Information -InformationAction Continue -MessageData $ImportString
    Import-Module $line.FileLocation -Force
}

