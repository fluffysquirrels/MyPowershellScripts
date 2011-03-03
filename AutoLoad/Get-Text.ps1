function Get-Text ($fn)
{
    $path = convert-path $fn
    [System.IO.File]::ReadAllText($path)
}