function Get-Text 
(
    [Parameter(ValueFromPipeline = $true)]
    [IO.FileInfo]
        $fileInfo
)
{
    process
    {
        if($fileInfo -ne $null) {
            $fullName = $fileInfo.FullName
        }
        $fullName = convert-path $fullName
        $text = [System.IO.File]::ReadAllText($fullName)
        return $text
    }
}