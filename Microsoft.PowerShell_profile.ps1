$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDir = split-path $profile

function Load-AutoLoadScripts($path)
{
    if(!(test-path $path)) {
        Write-Host "Skipping missing auto-load directory $path" -fore Yellow
        return
    }

    $toLoad = @(gci -recurse $path | 
               ?{$_ -is "System.IO.FileInfo" -and
               $_.Extension -eq ".ps1" -and
               $_.FullName -ne $profile})
               
    foreach($script in $toLoad)
    {
        . Load-Script $script
    }
}
function Load-Script($scriptFile)
{
    # If $scriptFile is a path string, fetch the fileinfo from that path.
    if ($scriptFile -is "String")
    {
        if(test-path $scriptFile) {
            $scriptFile = gi $scriptFile
        }
        else {
            Write-Host "Skipping missing script $scriptFile" -fore Yellow
            return
        }
    }
    
    # $scriptFile is a fileinfo object.
    write-host ("Loading {0}\" -f $scriptFile.Directory.FullName) -nonewline
    write-host $scriptFile.Name -foregroundcolor yellow
    
    . $scriptFile.FullName
}

function Load-ParkerFoxScripts()
{
    if(Is-AtWork)
    {
        . Load-Script "D:\Projects\Git\LoanBookUK - Shallow\DeployTools\Scripts\Main.ps1"
        . Load-Script "D:\Projects\Git\AspNetStats\Scripts\Poller.ps1"
        . Load-Script "D:\Projects\Git\LoanBookUK - Shallow\DeployTools\Scripts\For deployment server\Setup IIS lib.ps1"
    }
    else
    {
        # . Load-Script "C:\Data\Code\Parker Fox\LoanBook\DeployTools\Scripts\Main.ps1"
        . Load-Script "C:\Data\Code\Parker Fox\Git\LoanBook\DeployTools\Scripts\Main.ps1"
    }
}

function Is-AtWork()
{
    $workPcName = "BUNGLE"
    $thisPcName = gc env:computername
    
    $atWork = $thisPcName -eq $workPcName
    
    if(!$atWork)
    {
        Write-Host "Not loading Parker Fox scripts because we're on '$thisPcName', not '$workPcName'."
    }
    
    return $atWork
}



"`nLoading profile scripts . . . `n"
. Load-AutoLoadScripts (join-path $profileDir "AutoLoad")
""
Init-Ssh
. Load-Script(join-path $profileDir "posh-git\profile.example.ps1")
""
. Load-ParkerFoxScripts
""
" ************* "
""
""
""