$ErrorActionPreference = "Stop"

# ************ Load other profile scripts ************

$profileDir = split-path $profile

function Load-AutoLoadScripts
(
    $path,
    [switch] $verbose = $false
)
{
    if(!(test-path $path)) {
        Write-Host "Skipping missing auto-load directory $path" -fore Yellow
        return
    }
    
    Write-Host "Loading scripts from '$path' and sub-directories."

    $toLoad = @(gci -recurse $path | 
               ?{$_ -is "System.IO.FileInfo" -and
               $_.Extension -eq ".ps1" -and
               $_.FullName -ne $profile})
               
    foreach($script in $toLoad)
    {
        . Load-Script $script -verbose:$verbose
    }
}
function Load-Script
(
    $scriptFile,
    [switch] $verbose = $false
)
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
    
    if($verbose) {
        # Note: $scriptFile is a fileinfo object.
        write-host ("Loading {0}\" -f $scriptFile.Directory.FullName) -nonewline
        write-host $scriptFile.Name -foregroundcolor yellow
    }
    
    . $scriptFile.FullName
}

function Load-ParkerFoxScripts()
{
    if(Is-AtWork)
    {
        . Load-Script "D:\Projects\SVN\DeployTools\trunk\Scripts\Main.ps1" -verbose
        . Load-Script "D:\Projects\SVN\DeployTools\trunk\Scripts\For deployment server\Setup - IIS lib.ps1" -verbose
        . Load-Script "D:\Projects\SVN\AspNetStats\Scripts\Poller.ps1" -verbose
    }
    else
    {
        . Load-Script "C:\Data\Code\Parker Fox\Git\DeployTools\Scripts\Main.ps1" -verbose
    }
}

function Is-AtWork()
{
    return $env:computername -eq "BUNGLE"
}

function Load-Profile() {

    "`nLoading profile scripts . . . `n"
    . Load-AutoLoadScripts (join-path $profileDir "AutoLoad")
    Import-Module pscx
    Import-Module posh-git
    # Import-Module PowerTab

    . Load-ParkerFoxScripts
    ""
    Init-Ssh
    ""
    " ************* "
    ""
    ""
    ""
}

. Load-Profile