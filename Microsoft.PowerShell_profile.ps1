$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDirectory = split-path $profile

function Load-ProfileScripts {
    $autoLoadPath = join-path $profileDirectory "AutoLoad"
    $toLoad = (gci -recurse $autoLoadPath | ?{$_.FullName -ne $profile})
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

"`nLoading profile scripts . . . `n"
. Load-ProfileScripts
""
. Load-Script ("D:\Projects\Git\LoanBook2\DeployTools\ParkerFox build and deploy.ps1")
""