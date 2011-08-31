$Backup_PF_TargetDir = "N:\Users\ahelfet\backup"
$Backup_PF_LogfileName = $Backup_PF_TargetDir + "\BackupLog.txt"

function Backup-Work([switch]$dryRun = $false)
{
    Copy-TomboyNotesToDropbox

    Write-Host ""
    
    $machineName = (gc env:COMPUTERNAME)
    if($machineName -ne $MachineName_Work)
    {
        Write-Host "On '$machineName', not '$MachineName_Work'!"
        Write-Host "Backup is only set up on '$MachineName_Work'"
        return
    }

    $startMessage = "$([DateTime]::Now) -- started backup"
    $startMessage >> $Backup_PF_LogfileName
    write-host $startMessage, "`n"

    Write-Host ""
    
    $allFromDToCopy = (
        "D:\Documents",
        "D:\Projects\SVN\Test xml",
        "D:\Projects\SVN\Utility SQL",
        "D:\Run box shortcuts"
        )
    
    $allFromDToCopy += @(Backup-Work.GetGitDataDirectories)
    
    function DoBackupCopy($from, $to)
    {
        Backup-LoggedCopy $from $to -dryRun:$dryRun
    }
    
    foreach($from in $allFromDToCopy)
    {       
        $to = join-path $Backup_PF_TargetDir ($from.Replace("D:", ""))
        
        DoBackupCopy $from $to
    }
    
    # Backup PowerShell profile
    DoBackupCopy (split-path $profile) (join-path $Backup_PF_TargetDir "WindowsPowerShell")
    # Backup Tomboy
    DoBackupCopy "C:\Users\Alex\AppData\Roaming\Tomboy\notes"  (join-path $Backup_PF_TargetDir "Tomboy notes")
    # Backup Desktop
    DoBackupCopy "C:\Users\Alex\Desktop"  (join-path $Backup_PF_TargetDir "Desktop")
    
    $endMessage = "$([DateTime]::Now) -- finished backup"
    $endMessage, "`n" >> $Backup_PF_LogfileName
    write-host "`n", $endMessage
}

function Copy-TomboyNotesToDropbox() {
    $from = "C:\Users\Alex\AppData\Roaming\Tomboy\notes"
    $to = "D:\Dropbox\Tomboy notes - work"
    
    Write-Host "Copying Tomboy notes to dropbox"
    Write-Host "    from: $from"
    Write-Host "    to: $to"
    
    rm -recurse "$to\*"
    copy -recurse $from $to    
}

function Backup-Work.GetGitDataDirectories()
{
    # Return .git directories of all top level dirs in Git projects folder.

    return gci "D:\Projects\Git" |
        ?{$_ -is "System.IO.DirectoryInfo"} |
        ?{test-path (join-path $_.FullName ".git")} |
        %{join-path $_.FullName ".git"}
}

function Backup-LoggedCopy($from, $to, [switch]$dryRun)
{
    Write-Host "copy from '$from' to '$to'; `$dryRun = $dryRun"
    
    if($dryRun -eq $false)
    {
        Ensure-Directory $to
        $output = robocopy $from $to /mir
    }
}

function Ensure-Directory($path) {
    if(!(test-path $path)) {
        $newDir = new-item $path -type directory
    }
}

 Export-ModuleMember -function "Backup-Work"