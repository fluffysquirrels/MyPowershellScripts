function Copy-Structure
(
    $files,
    [string] $targetPath,
    [string] $filesBasePath,
    [switch] $force = $false
)
{
    foreach ($file in $files)
    {
        $fromPath = $file.FullName
        $targetFilePath = Join-Path $targetPath $file.FullName.Substring($filesBasePath.length)
        
        $targetFileParentPath = (split-path $targetFilePath)
        Ensure-Directory $targetFileParentPath
        
        copy-item -path $fromPath -destination $targetFilePath -force:$force
    }
}