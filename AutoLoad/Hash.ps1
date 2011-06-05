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
            
            $fileBytes = [IO.File]::ReadAllBytes($path)

            $hasher = new-object "Security.Cryptography.SHA1Managed"
            $hashBytes = $hasher.ComputeHash($fileBytes)

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
