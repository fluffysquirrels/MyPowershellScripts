$Backup_TargetDir = "Q:\Alex H backup"

function Backup([switch]$dryRun = $false, [switch]$includeGitRepositories = $true)
{
    write-host "$([DateTime]::Now) -- started backup`n"

    if (!$dryRun)
    {
        Write-Host "Deleting $Backup_TargetDir\*`n"
        del -recurse -force (join-path $Backup_TargetDir *)
    }

    $allFromDToCopy = (
        "D:\Documents",
        "D:\Projects\Git\*.*",
        "D:\Projects\SQL tool scripts",
        "D:\Run box shortcuts"
        )
    
    if($includeGitRepositories)
    {
        $allFromDToCopy += Backup-GetGitDataDirectories
    }
    
    function DoBackupCopy($from, $to)
    {
        Backup-LoggedCopy $from $to -dryRun:$dryRun
    }
    
    foreach($from in $allFromDToCopy)
    {
        $to = (join-path $Backup_TargetDir (split-path $from.Replace("D:", "")))
        
         DoBackupCopy $from $to
    }
    
    # Backup profile
    DoBackupCopy (split-path $profile) $Backup_TargetDir
    # Backup Tomboy
    DoBackupCopy "C:\Users\Alex\AppData\Roaming\Tomboy\notes"  (join-path $Backup_TargetDir "Tomboy notes")
    
    write-host "`n$([DateTime]::Now) -- finished backup"
}

function Backup-GetGitDataDirectories()
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