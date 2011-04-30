function Backup-Beast()
{
    $backupDrive = Get-BeastBackupDrivePath
    $backupBase = join-path $backupDrive "Backup"
    $logPath = join-path $backupBase "robo_log.txt"
    
    if(test-path $logPath)
    {
        del $logPath
    }
    
    function BackupDir($source, $dest)
    {
        robocopy $source $dest /mir /eta /tee "/log+:$logPath"
    }
    
    BackupDir "c:\Users\Alex\AppData\Roaming\Tomboy\notes"    (join-path $backupBase "Tomboy notes")
    BackupDir "c:\Users\Alex\Documents\WindowsPowerShell"     (join-path $backupBase "WindowsPowerShell")
    BackupDir "c:\Data"                                       (join-path $backupBase "Data")
}
function Get-BeastBackupDrivePath()
{
    $backupVolumeName = "Cigar Case"
    
    $volumes = @(gwmi win32_logicaldisk |
        ?{$_.drivetype -eq 3 -and $_.VolumeName -eq $backupVolumeName} |
        %{$_.deviceid})

    if($volumes.Length -ne 1) {
        throw "Couldn't find exactly one backup drive with volume name '$backupVolumeName'."
    }
    
    return $volumes[0]
}