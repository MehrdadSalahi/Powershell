##### 
##### Scripter: Mehrdad Salahi
##### WhatsApp: +989196266748
##### Email   : mehrdadsalahi@ymail.com
##### 

## Check main number with random number
function CheckNumber(){
    Param($Number, $Guess)
    
    if($Number -eq $Guess){
        return 'done'
    }elseif($Number -lt $Guess){
        return 'lt'
    }else{
        return 'gt'
    }
}

## Main
Clear-Host

$min = 0
$max = 1000000

$numberMain = Read-Host "Enter your number" -AsSecureString 
$numberMain = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($numberMain))
$numberMain = [System.Convert]::ToInt32($numberMain)

do{
    $numberGuess = Get-Random -Minimum $min -Maximum $max
    $check = CheckNumber -Guess $numberGuess -Number $numberMain

    if($check -eq 'done'){
        break
    }elseif($check -lt 'lt'){
        $min = $numberGuess
    }
    else{
        $max = $numberGuess
    }

    Write-Host "Input Number is $check than $numberGuess"

} while($true)

Write-Host "Input Number is: $numberMain" -ForegroundColor Green
