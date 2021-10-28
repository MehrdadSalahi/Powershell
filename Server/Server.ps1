Using module '.\Functions.psm1'

## Main
Clear-Host

# Add Server to List Servers File
$Key = SetKey -String (Read-Host "Enter Key")
AddServer -Key $Key

# Get Server From List Servers File
$Key = SetKey -String (Read-Host "Enter Key")
$Servers = GetServer -IP '192.168.150.*'

# Remote to the server(s)
RemoteServer -Server $Servers -Key $Key
