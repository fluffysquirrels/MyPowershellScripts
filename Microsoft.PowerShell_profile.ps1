New-Alias new New-Object -ErrorAction SilentlyContinue

function Get-Type
{
    [AppDomain]::CurrentDomain.GetAssemblies() | %{$_.GetModules()} | %{$_.FindTypes($null, $null)}
}

function Restart-Ps {
    $cline = "`"/c start powershell.exe -noexit -c `"set-location '{0}'" -f $pwd.path
    cmd $cline
    Stop-Process -Id $PID
}
function Load-ProfileScripts {
    write-output "`nLoading profile scripts . . . `n"
    
    $autoLoadPath = join-path (split-path $profile) "AutoLoad"
    $toLoad = (gci -recurse $autoLoadPath | ?{$_.FullName -ne $profile})
    foreach($scriptFile in $toLoad)
    {
        write-output ("Loading {0}" -f $scriptFile.Name)
        . $scriptFile.FullName
    }
    write-output ""
}

# For explanation of the dot below: http://blairconrad.wordpress.com/2010/01/29/expand-your-scope-you-can-dot-source-more-than-just-files/
. Load-ProfileScripts