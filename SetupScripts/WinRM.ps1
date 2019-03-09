# Script to ensure Powershell remoting is enabled on Base Windows machine

# todo: turn this into DSC as soon as possible
Write-Information -MessageData "Setting up Windows Remote Management"

Enable-PSRemoting -Force -Verbose

# Initially set WinRM to allow connections from all machines
# todo: Scope this to only be the machines on the test network
Write-Information -MessageData "Setting WSMan to * for setup"
Set-Item WSMan:\localhost\Client\TrustedHosts * -Force
