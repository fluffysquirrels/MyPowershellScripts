function Copy-Structure($toCopy, [string] $to, [string] $toCopyBasePath)
{
    foreach ($file in $toCopy)
    {
        $fromPath = $file.FullName
        $toPath = Join-Path $to $file.FullName.Substring($toCopyBasePath.length)
        
        $toParentPath = (split-path $toPath)
        if(-not (test-path $toParentPath))
        {
            # File's parent directory doesn't exist.
            
            # Seemingly pointless assignment is to eat the shell output. Without it PowerShell prints the params of the new dir.
            $newDir = new-item -type directory $toParentPath
        }
        
        copy-item -path $fromPath -destination $toPath
    }
}