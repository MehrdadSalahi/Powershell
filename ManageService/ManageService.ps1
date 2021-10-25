##### Scripter: Mehrdad Salahi
##### WhatsApp: +989196266748

## Manage Service
function ManageService(){
    Param($ServiceName = '*', $Status = 'Show', $IP)
    
    $ValidateStatus = @('Show', 'Start', 'Stop', 'Pause', 'Resume')
    if($ValidateStatus -notcontains $Status){
        Write-Host 'Status undefined!' -ForegroundColor Red; return
    }

    $cred = (Get-Credential -Message "Server: $IP")
    $services = Get-WmiObject Win32_Service -Filter "Name LIKE '%$ServiceName%'" -ComputerName $IP -Credential $cred |
                Out-GridView -PassThru
    
    if($services.Count -eq 0){
        Write-Host 'Error: No selected Service!' -ForegroundColor Red; return
    }

    $result = $null
    switch($Status){
        'Show'    {$result = $services;return         }
        'Start'   {$result = $services.StartService() }
        'Stop'    {$result = $services.StopService()  }
        'Pause'   {$result = $services.PauseService() }
        'Resume'  {$result = $services.ResumeService()}
    }

    $value = ""
    switch($result.ReturnValue){
        "0" 	{$value = "The request was accepted."}
        "1" 	{$value = "Error: The request is not supported."}
        "2" 	{$value = "Error: The user did not have the necessary access."}
        "3" 	{$value = "Error: The service cannot be stopped because other services that are running are dependent on it."}
        "4" 	{$value = "Error: The requested control code is not valid, or it is unacceptable to the service."}
        "5" 	{$value = "Error: The requested control code cannot be sent to the service because the state of the service (Win32_BaseService.State property) is equal to 0, 1, or 2."}
        "6" 	{$value = "Error: The service has not been started."}
        "7" 	{$value = "Error: The service did not respond to the start request in a timely fashion."}
        "8" 	{$value = "Error: Unknown failure when starting the service."}
        "9" 	{$value = "Error: The directory path to the service executable file was not found."}
        "10"	{$value = "Error: The service is already running."}
        "11"	{$value = "Error: The database to add a new service is locked."}
        "12"	{$value = "Error: A dependency this service relies on has been removed from the system."}
        "13"	{$value = "Error: The service failed to find the service needed from a dependent service."}
        "14"	{$value = "Error: The service has been disabled from the system."}
        "15"	{$value = "Error: The service does not have the correct authentication to run on the system."}
        "16"	{$value = "Error: This service is being removed from the system."}
        "17"	{$value = "Error: The service has no execution thread."}
        "18"	{$value = "Error: The service has circular dependencies when it starts."}
        "19"	{$value = "Error: A service is running under the same name."}
        "20"	{$value = "Error: The service name has invalid characters."}
        "21"	{$value = "Error: Invalid parameters have been passed to the service."}
        "22"	{$value = "Error: The account under which this service runs is either invalid or lacks the permissions to run the service."}
        "23"	{$value = "Error: The service exists in the database of services available from the system."}
        "24"	{$value = "Error: The service is currently paused in the system."}
    }
    
    $color = "Green"
    if($result.ReturnValue -ne 0){$color = "Red"}

    Write-Host $value -ForegroundColor $color
}

## Choose Service Name, Status and target server/IP
Clear-Host
ManageService -ServiceName 'w3svc' -Status 'Start' -IP 192.168.150.100