function Get-AllScheduledTasks($machines)
{
    $allTasks = @()
    
    foreach($machine in $machines)
    {
        $machineTasks = Get-AllScheduledTasks-EachMachine($machine)
        $allTasks += $machineTasks
    }
    
    return $allTasks
}

function Get-AllScheduledTasks-EachMachine($machine)
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
        
        _TaskScheduler-AnnotateTask $task $service
        
        $rv += $task
    }
    
    return $rv
}

function _TaskScheduler-AnnotateTask($task, $service)
{
    $task | add-member noteproperty "Machine" $service.TargetServer
    
    $taskXml = [xml] $task.Xml
    
    $command = $taskXml.Task.Actions.Exec.Command
    $args = $taskXml.Task.Actions.Exec.Arguments
    
    $task | add-member noteproperty "Command" $command
    $task | add-member noteproperty "Arguments" $args
}