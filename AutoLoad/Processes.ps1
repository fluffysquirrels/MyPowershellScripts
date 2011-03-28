function Kill-Process
(
    [string[]]  $Name,
    [Int32[]]   $Id
) {
    (Get-Process @psboundparameters) | % {$_.Kill()}
}

function Kill-Cassini() {
    Get-Process webdev* | %{$_.kill()}
}
