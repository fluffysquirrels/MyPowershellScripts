function Get-Text 
(
    [Parameter(
        ValueFromPipelineByPropertyName=$true)]
        $PSPath
)
{
    process
    {
        $PSPath = convert-path $PSPath
        $text = [System.IO.File]::ReadAllText($PSPath)
        return $text
    }
}