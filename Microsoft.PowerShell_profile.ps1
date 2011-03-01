$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDirectory = split-path $profile

function Load-AutoLoadProfileScripts {
    $autoLoadPath = join-path $profileDirectory "AutoLoad"
    $toLoad = (gci -recurse $autoLoadPath | ?{$_ -is "System.IO.FileInfo" -and $_.FullName -ne $profile})
    foreach($scriptFile in $toLoad)
    {
        . Load-Script($scriptFile)
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
    $parkerFoxBuildScriptFn = "D:\Projects\Git\LoanBookUK\DeployTools\Scripts\Build and deploy.ps1"

    $workPcName = "BUNGLE"
    $thisPcName = gc env:computername
    
    if($thisPcName -eq $workPcName)
    {
        . Load-Script $parkerFoxBuildScriptFn
    }
    else
    {
        "Not loading Parker Fox scripts because we're on '$thisPcName', not '$workPcName'."
    }
}



"`nLoading profile scripts . . . `n"
. Load-AutoLoadProfileScripts
""
. Load-ParkerFoxScriptsIfAtWork
""