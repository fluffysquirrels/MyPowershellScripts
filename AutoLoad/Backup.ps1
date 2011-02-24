$Backup_TargetDir = "Q:\Alex H backup"

function Backup([switch]$dryRun = $false)
{
    if (!$dryRun)
    {
        Write-Host "Deleting $Backup_TargetDir\*`n"
        del -recurse (join-path $Backup_TargetDir *)
    }

    $allFromDToCopy = (
        "D:\Documents",
        "D:\Projects\Git\*.*",
        "D:\Projects\SQL scripts",
        "D:\Run box shortcuts"
        )
    
    $allFromDToCopy += Backup-GetGitDataDirectories
    
    foreach($from in $allFromDToCopy)
    {
        $to = (join-path $Backup_TargetDir (split-path $from.Replace("D:", "")))
        
        Backup-LoggedCopy $from $to -dryRun:$dryRun
    }
    
    Backup-LoggedCopy (split-path $profile) $Backup_TargetDir -dryRun:$dryRun
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