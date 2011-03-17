function prompt {
    Write-Host -foregroundcolor yellow -nonewline -object ($(
        if (test-path variable:/PSDebugContext) { '[DBG]: ' } else { '' }
    ) + 'PS ')

    Write-Host($pwd) -nonewline -foregroundcolor yellow
    
    # Git Prompt
    $Global:GitStatus = Get-GitStatus
    Write-GitStatus $GitStatus
     
    
    Write-Host ">" -foregroundcolor yellow -nonewline
    
    return " "
}