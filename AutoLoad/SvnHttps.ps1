function Switch-SvnToHttps() {
    $localHardDrivePaths = gwmi win32_logicaldisk | ?{$_.DriveType -eq 3} | %{ $id = $_.DeviceID; "$id\"}

    $svnCheckoutRoots = $localHardDrivePaths % {Get-SvnCheckoutRoots $_}
}

function Get-SvnCheckoutRoots($path) {
    # Write-Verbose "Searching '$path'"
    Write-Progress -Activity "Searching for SVN working copies: " -Status $path

    $possSvnPath = join-path $path ".svn"
    
    if (test-path $possSvnPath) {
        Write-Verbose "Found SVN working copy '$path'"
        return $path
    }

    $oldEAP = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    
    try {
        $childPaths = @(gci -force $path | ?{$_.psiscontainer} | %{$_.fullname})
    }
    catch {
        $ex = $Error[0].ErrorRecord.Exception
            
        if($ex -is "System.UnauthorizedAccessException") {
            # Accessed denied to current path. Return nothing.
            return
        }
        else {
            # Some other exception, re-throw.
            throw $ex
        }
    }
    
    $ErrorActionPreference = $oldEAP
    
    foreach($childPath in $childPaths) {
        Get-SvnCheckoutRoots $childPath
    }
}