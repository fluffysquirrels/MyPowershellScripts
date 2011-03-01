function Get-AllScheduledTasks($machine)
{
    $service = Get-ScheduleService $machine
    
    $t = (Get-AllScheduledTasks-Recursive $service -path "\")
    
    return $t
}

function Get-ScheduleService($machine = "localhost") {
    if (!(Get-IsAdmin)) {
        Write-Host "This command must be run with administrator privileges."
        Write-Host "Try running the command again after starting PowerShell as an administrator."
        throw
    }
    
    $service = new-object -com "Schedule.Service"
    
    $service.Connect($machine)
    
    return $service
}

function Get-AllScheduledTasks-Recursive($service, $path)
{
    $folder = $service.GetFolder($path)
    
    $tasks = _TaskScheduler-GetFolderTasks $service $path
    
    $subFolders = $folder.GetFolders(0 # Reserved param; must equal 0.
                                        )
    
    foreach($subFolder in $subFolders) {
        $subTasks = Get-AllScheduledTasks-Recursive $service $subFolder.Path
        $tasks = $tasks + $subTasks
    }
    
    return $tasks
}

function _TaskScheduler-GetFolderTasks($service, $path)
{
    $rv = @()
    
    $folder = $service.GetFolder($path)
    
    foreach($task in $folder.GetTasks(1) #1 = include hidden tasks, 0 = don't.
                                         ){
        $task = [psobject] $task
        
        ($task | add-member noteproperty "Machine" $service.TargetServer)
        
        $rv += $task
    }
    
    return $rv
}
