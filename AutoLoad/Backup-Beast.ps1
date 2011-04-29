function Backup-Beast()
{
    $backupBase = "E:\Backup"
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