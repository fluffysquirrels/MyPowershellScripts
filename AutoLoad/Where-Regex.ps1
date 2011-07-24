function Where-Regex
(
    [regex] $regex
) {
    process {
        if($_ -match $regex) {
            write $_
        }
    }
}