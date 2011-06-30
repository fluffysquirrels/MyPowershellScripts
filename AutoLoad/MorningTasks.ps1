function Run-MorningTasks {
    cd $profileDir
    
    Write-Host "Pulling from WindowsPowerShell Git repository . . ."
    git pull
    . p;

    Write-Host ""
    Write-Host "*****"
        
    Write-Host "Pulling from Parker Fox SVN repository . . ."
    Fetch-AllGitSvn

    Write-Host ""
    Write-Host "*****"
    
    if($env:COMPUTERNAME -eq "BUNGLE") {
        Write-Host "Backing up BUNGLE . . ."
        Backup-Bungle
    }
    else {
        Write-Host "Can't run backup, not on BUNGLE!"
    }
}