##### Scripter: Mehrdad Salahi
##### WhatsApp: +989196266748

# Main
Clear-Host

# Query File
$queryFile = 'C:\Users\Administrator\Desktop\queryfile.txt'

# List of Servers
$Servers = @(
    '192.168.150.2',
    '192.168.150.3',
    '192.168.151.22'
)

# Set output file and create neccesary
$outputFile = "C:\Users\Administrator\Desktop\output.txt"
if(-not(Test-Path -Path $outputFile)){
    New-Item -Path $outputFile -ItemType File 
}

# Get safely password of database
# This password is the same for all Servers.
$passDBSecure = Read-Host "Database Password" -AsSecureString
$x = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($passDBSecure)
$passDB = [Runtime.InteropServices.Marshal]::PtrToStringAuto($x)

# Run query for each server
foreach($Server in $Servers){
    # Database Parameters
    $options = @{
        ServerInstance = $Server
        Username       = 'sa'
        Password       = $passDB
        Database       = 'master'
        InputFile      = $queryFile
    }

    # Get Result Query by Command
    $result = Invoke-Sqlcmd @options
    
    # Set Output Format
    $output = $result | Format-Table

    # Save to File (with Encoding)
    $output | Out-File $outputFile -Encoding utf8 -Append
}

