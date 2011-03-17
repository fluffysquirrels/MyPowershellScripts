function prompt {
    $host.ui.rawui.WindowTitle = "PS " + $(get-location)
    
    Write-Host -foregroundcolor yellow -nonewline -object ($(
        if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }
    ) + 'PS ')

    Write-Host($pwd) -nonewline -foregroundcolor yellow
    
    if      (Write-GitPrompt) {}
    elseif  (Write-SvnPrompt) {}

    Write-Host ">" -foregroundcolor yellow -nonewline
    
    return " "
}

function Write-GitPrompt {
    $Global:GitStatus = Get-GitStatus
    
    if($GitStatus -ne $null)
    {
        Write-GitStatus $GitStatus
        return $true
    }
    
    return $false
}

function Write-SvnPrompt {
    if(!(Test-Path .svn)) {
        return $false
    }
    
    $other = 0
    $added = 0
    $modified = 0
    
    switch -regex (svn st) {
       "^\?"    { $other    += 1 }
       "^A"     { $added    += 1 }
       "^M"     { $modified += 1 }
       default  {}
    }

    Write-Host " [" -nonewline
    Write-Host "SVN" -nonewline -fore cyan
    
    Write-Host " add:" -nonewline -fore yellow
    Write-Host $added -nonewline -fore green
    Write-Host " mod:" -nonewline -fore yellow
    Write-Host $modified -nonewline -fore green
    Write-Host " oth:" -nonewline -fore yellow
    Write-Host $other -nonewline -fore green
    
    Write-Host "]" -nonewline

    return $true
}