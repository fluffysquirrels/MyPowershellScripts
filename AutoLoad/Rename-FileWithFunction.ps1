function Rename-FileWithFunction
(
    [scriptblock]
        $function,
    
    [Parameter(ValueFromPipeline=$true)]
    [IO.FileInfo]
        $fileInfo,
        
    [switch]
        $DoIt = $false
)
{
    process {
        [IO.FileInfo] $file = $_
        $oldName = $file.Name
        
        [string] $newName = $oldName | % $function
        
        $fullDirectoryPath = $file.Directory.FullName;
        $fullNewName = join-path $fullDirectoryPath $newName

        if( $newName -eq $oldName -or
            $newName -eq $null -or
            $newName -eq "") {

            return
        }
        
        if($DoIt) {
            $file.FullName
            $fullNewName
        
            $newFile =
                mv `
                    -LiteralPath $file.FullName `
                    -Destination $fullNewName `
                    -PassThru
                    
            write $newFile
        }
        else {
            # $DoIt = $false.
            # Just print -WhatIf.
            $oldName = $file.Name
            "Old name: $oldName"
            "New name: $newName"
            ""
        }
    }
}