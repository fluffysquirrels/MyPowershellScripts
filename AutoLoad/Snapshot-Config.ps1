function Snapshot-Config
(
    $treeRootPath = ".",
    $backupRootPath =  (Get-DefaultSnapshotConfigDir)
)
{
    $treeRootPath = convert-path $treeRootPath
    $files = @(gci -recurse $treeRootPath -filter *.config)
    
    foreach($file in $files) {
        $relPath = $file.FullName.Substring($treeRootPath.length)
        $targetPath = join-path $backupRootPath $relPath
        mkdir -force (split-path $targetPath) | Out-Null
        cp $file.fullname $targetPath
    }
    
    Write-Host "Configuration written to $backupRootDir"
}

function Get-DefaultSnapshotConfigDir()
{
    $userDir = $env:userprofile
    $machine = $env:COMPUTERNAME
    $dateStr = [DateTime]::Now.ToString("yyyy-MM-dd_HH-mm")
    return "$userDir\Documents\ConfigSnapshot_$($machine)_$dateStr"
}


