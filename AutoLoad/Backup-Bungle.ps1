$Backup_PF_TargetDir = "Q:\Alex H backup"
$Backup_PF_LogfileName = $Backup_PF_TargetDir + "\BackupLog.txt"

function Backup-Bungle([switch]$dryRun = $false, [switch]$includeGitRepositories = $true)
{
    $machineName = (gc env:COMPUTERNAME)
    if($machineName -ne "BUNGLE")
    {
        Write-Host "On '$machineName', not 'BUNGLE'!"
        Write-Host "Backup is only set up on 'BUNGLE'"
        return
    }

    $startMessage = "$([DateTime]::Now) -- started backup"
    $startMessage >> $Backup_PF_LogfileName
    write-host $startMessage, "`n"

    if (!$dryRun)
    {
        $toDelete = (gci $Backup_PF_TargetDir | ?{$_.PSIsContainer} | %{$_.FullName})
        $toDelete | % {
            Write-Host "Deleting $_\"
            del -recurse -force $_
        }
    }

    Write-Host ""
    
    $allFromDToCopy = (
        "D:\Documents",
        "D:\Projects\Git\*.*",
        "D:\Projects\SQL tool scripts",
        "D:\Run box shortcuts"
        )
    
    if($includeGitRepositories)
    {
        $allFromDToCopy += Backup-Bungle-GetGitDataDirectories
    }
    
    function DoBackupCopy($from, $to)
    {
        Backup-LoggedCopy $from $to -dryRun:$dryRun
    }
    
    foreach($from in $allFromDToCopy)
    {
        $to = (join-path $Backup_PF_TargetDir (split-path $from.Replace("D:", "")))
        
         DoBackupCopy $from $to
    }
    
    # Backup PowerShell profile
    DoBackupCopy (split-path $profile) $Backup_PF_TargetDir
    # Backup Tomboy
    DoBackupCopy "C:\Users\Alex\AppData\Roaming\Tomboy\notes"  (join-path $Backup_PF_TargetDir "Tomboy notes")
    
    
    $endMessage = "$([DateTime]::Now) -- finished backup"
    $endMessage, "`n" >> $Backup_PF_LogfileName
    write-host "`n", $endMessage
}

function Backup-Bungle-GetGitDataDirectories()
{
    return gci "D:\Projects\Git" | ?{$_ -is "System.IO.DirectoryInfo"} | ?{test-path (join-path $_.FullName ".git")} | %{join-path $_.FullName ".git"}
}

function Backup-LoggedCopy($from, $to, [switch]$dryRun)
{
    Write-Host "copy from '$from' to '$to'; `$dryRun = $dryRun"
    
    if($dryRun -eq $false)
    {
        Ensure-Directory $to
        copy -recurse $from $to
    }
}

function Ensure-Directory($path) {
    if(!(test-path $path)) {
        $newDir = new-item $path -type directory
    }
}