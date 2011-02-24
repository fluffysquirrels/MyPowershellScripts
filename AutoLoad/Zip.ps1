function Out-Zip
(
    $zipPath,
    $files
)
{
    if (-not $zipPath.EndsWith('.zip')) {$zipPath += '.zip'} 

    $zip = $null
    
    if (-not (test-path $zipPath)) { 
        $zip = new-zip $zipPath
    }
    else {
        $zip = open-zip $zipPath
    }
    
    $files | % {$zip.CopyHere((Get-RootedPathString($_)))} 
}

function Get-RootedPathString
(
    $fileOrPath
)
{
    if ( $fileOrPath -is "String" ) {
        return convert-path $fileOrPath
    }
    
    if ( $fileOrPath -is "System.IO.FileSystemInfo" ) {
        return $fileOrPath.FullName
    }
    
    # Unknown type
    Write-Error "Couldn't work out how to turn '$fileOrPath' into a rooted path string"
}

function New-Zip
(
    $zipPath
)
{
    # Write magical .zip header
    set-content $zipPath ("PK" + [char]5 + [char]6 + ("$([char]0)" * 18)) 
    
    return (Open-Zip $zipPath)
}

function Open-Zip
(
    $zipPath
)
{
    $zipRootedPath = convert-path $zipPath
    $zipFile = $null
    
    if ($zipRootedPath -ne $null) {
        $zipFile = (new-object -com shell.application).NameSpace($zipRootedPath)
    }
    
    if ($zipFile -eq $null) {
        Write-Error "Failed to open zip file '$zipRootedPath'"
    }
    
    return $zipFile
}

function Extract-Zip
(
    [string] $zipPath,
    [string] $outPath
)
{
    if (-not (test-path $zipPath)) {
        Write-Error "Couldn't find zip file at '$zipPath'"
        return
    }
    
	$zipPath = convert-path $zipPath
    
    if((test-path($outPath)) -eq $false)
    {
        $newDir = new-item -itemtype "directory" $outPath 
    }

    $outRootedPath = convert-path $outPath
    $shell = new-object -com shell.application
    
    $zipShell = $shell.NameSpace($zipPath)
    $outShell = $shell.NameSpace($outRootedPath)
    
    $outShell.CopyHere($zipShell.Items())
}
