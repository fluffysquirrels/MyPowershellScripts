function Lock-File($fileName)
{
    try
    {
        Write-Host "Locking '$fileName'"
        $fs = new-object IO.FileStream @(
            $sip,
            [IO.FileMode]::OpenOrCreate,
            [IO.FileAccess]::ReadWrite,
            [IO.FileShare]::None)
        
        Write-Host "File locked. Press any key to unlock . . ."
        
        [Console]::ReadKey($true) | Out-Null
        
        $fs.Close()
        
        Write-Host "File unlocked."
    }
    finally
    {
        if($fs -ne $null) {
            $fs.Dispose()
            $fs = $null
        }
    }
}

