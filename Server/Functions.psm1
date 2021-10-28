$ServerFile = [System.IO.Path]::GetDirectoryName($PSCommandPath)
$ServerFile = "$($ServerFile)\Servers.json"

$json = Get-Content $ServerFile | Out-String
$Servers =  ConvertFrom-Json -InputObject $json

## Create Key
function SetKey{
    Param($String)
    $size = 16

    $Len = $String.Length
    $Pad = $size - $len

    if(($Len -lt $size)){
        $String = $String + "0" * $Pad
    }else{
        $String = $String.Substring(0, $size)
    }

    $Bytes = [System.Text.Encoding]::UTF8.GetBytes($String)
    return $Bytes
}

## Encrypt Data
function Encrypt(){
    Param($Data, $Key)

    $SecureString = New-Object System.Security.SecureString
    $Chars = $Data.toCharArray()
    foreach($Char in $Chars){
        $SecureString.AppendChar($Char)
    }
    
    $EncryptData = ConvertFrom-SecureString -SecureString $SecureString -Key $Key
    return $EncryptData
}

## Decrypt Data
function Decrypt(){
    Param($Data, $Key)

    $Data | ConvertTo-SecureString -Key $Key | ForEach-Object {
        [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($_))
    }
}

## Add Record Data to Json File
function AddServer(){
    Param($Key)

    $HostName = Read-Host "HostName"
    $IP       = Read-Host "IP"
    $Username = Read-Host "Username"
    $Password = Read-Host "Password" -AsSecureString
    $x2 = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($Password)
    $ClearPassword = [Runtime.InteropServices.Marshal]::PtrToStringAuto($x2)

    $Server = @{
        "HostName" = $HostName;
        "IP"       = $IP;
        "Username" = $Username;
        "Password" = Encrypt -Data $ClearPassword -Key $Key;
    } | ConvertTo-Json

    $Server = ConvertFrom-Json -InputObject $Server
    $Servers.Servers += $Server
    $Servers | ConvertTo-Json | Set-Content $ServerFile
}

## Get Server(s)
function GetServer(){
    Param($IP = '*', $HostName = '*')

    $Servers.Servers | Where-Object {($_.IP -like $IP) -and ($_.HostName -like $HostName)}
}

## Remote Server
function RemoteServer(){
    Param($Server, $Key)

    $Server | ForEach-Object {
        Write-Host "$($_.HostName) - $($_.IP)"

        $Password = Decrypt -Data $_.Password -Key $Key
        cmdkey /generic:$($_.IP) /user:$($_.Username) /password:$($Password)

        mstsc /v:$($_.IP)
        PAUSE
        
        cmdkey /delete:$($_.IP)
        Write-Host '-------------------------------------------'
    }
}