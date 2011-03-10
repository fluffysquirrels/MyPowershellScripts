$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDir = split-path $profile

function Load-AutoLoadScripts($path)
{
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
        $scriptFile = gi $scriptFile
    }
    
    # $scriptFile is a fileinfo object.
    write-host ("Loading {0}\" -f $scriptFile.Directory.FullName) -nonewline
    write-host $scriptFile.Name -foregroundcolor yellow
    
    . $scriptFile.FullName
}

function Load-ParkerFoxScriptsIfAtWork()
{
    if(Is-AtWork)
    {
        . Load-AutoLoadScripts "D:\Projects\Git\LoanBookUK - Shallow\DeployTools\Scripts"
        . Load-Script "D:\Projects\Git\AspNetStats\Scripts\Poller.ps1"
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
. Load-ParkerFoxScriptsIfAtWork
""
" ************* "
""
""
""