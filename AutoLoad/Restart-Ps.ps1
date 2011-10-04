function Restart-Ps {
    $cline = "/c start powershell.exe -noexit -c set-location '{0}'" -f $pwd.path
    cmd $cline
    Stop-Process -Id $PID
}