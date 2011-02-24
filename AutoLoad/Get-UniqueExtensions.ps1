function Get-UniqueExtensions([System.IO.FileSystemInfo[]] $paths)
{
    return ($paths | ?{ $_ -is "System.IO.FileInfo" }| %{$_.Extension} | sort -Unique)
}