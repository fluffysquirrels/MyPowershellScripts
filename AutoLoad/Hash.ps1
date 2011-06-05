function Get-SHA1($path)
{
    begin
    {
        if($path -ne $null) {
            $path = Convert-Path $path
            $pathInfo = gi $path
            
            if($pathInfo.PSIsContainer) {
                gci -recurse $path |
                    ? {!$_.PSIsContainer} |
                    % {get-sha1 $_.FullName}
                
                return
            }
            
            $hasher = new-object "Security.Cryptography.SHA1Managed"
            
            try {
                $fs = new-object "io.filestream" (
                    $path,
                    "Open",     # FileMode
                    "Read",     # FileAccess    -- what can we do?
                    "Read"      # FileShare     -- what can others do?
                    )
                $hashBytes = $hasher.ComputeHash($fs)
            }
            finally {
                if($fs -ne $null) {
                    $fs.Dispose()
                }
            }

            if($hashBytes -ne $null) {
                $hashString = [string]::join("", @($hashBytes | %{$_.tostring("x2")}))
                $outputLine = "$hashString '$path'"
                
                $hashInfo = new-object "PSObject"
                add-member -in $hashInfo NoteProperty "Path" $path
                add-member -in $hashInfo NoteProperty "HashBytes" $hashBytes
                add-member -in $hashInfo NoteProperty "HashString" $hashString
                add-member -in $hashInfo NoteProperty "OutputLine" $outputLine
                return $hashInfo
            }
        }
    }
    process
    {
        if($path -eq $null -and $_ -ne $null) {
            Get-SHA1 $_
        }
    }
}
