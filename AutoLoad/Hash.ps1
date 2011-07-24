function Get-SHA1
(
    $path,
    $pathBase,
    [switch] $relative = $true
)
{
    begin
    {
        if($path -ne $null) {
            $path = Convert-Path $path
            $pathInfo = gi $path
            
            if($pathInfo.PSIsContainer) {
                if($relative) {
                    $pathBase = $pathInfo.FullName
                }
            
                gci -recurse $path |
                    ? {!$_.PSIsContainer} |
                    % {Get-SHA1 $_.FullName -pathBase $pathBase}
                
                return
            }
            
            $hasher = new-object "Security.Cryptography.SHA1Managed"
            
            try {
                $fs = new-object "io.filestream" (
                    $path,
                    "Open",     # FileMode      -- Open, Create, that kind of thing
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
                $hashString = Convert-BytesToHexString
                if($pathBase -eq $null) {
                    $displayPath = $path
                }
                else {
                    $displayPath = $path.Replace($pathBase, "")
                }
                $outputLine = "$hashString $displayPath"
                
                $hashInfo = new-object "PSObject"
                add-member -in $hashInfo NoteProperty "Path"        $displayPath
                add-member -in $hashInfo NoteProperty "HashBytes"   $hashBytes
                add-member -in $hashInfo NoteProperty "HashString"  $hashString
                add-member -in $hashInfo NoteProperty "OutputLine"  $outputLine
                return $hashInfo
            }
        }
    }
    process
    {
        if($path -eq $null -and $_ -ne $null) {
            Get-SHA1 $_ -pathBase $pathBase
        }
    }
}

function Convert-BytesToHexString($bytes) {
    return [string]::join("", @($bytes | %{$_.tostring("x2")}))
}