function Get-ExceptionTypes
(
    [System.Exception]
        $ex
) {
    while($ex -ne $null) {
        Write-Host "InnerException:"
        Write-Host (Get-TypeHierarchy $ex)
        $ex = $ex.InnerException
    }
}

function Get-TypeHierarchy
(
    [object] $obj,
    [string] $delimiter = "`r`n    -->"
) {
    $ret = $delimiter
    
    if($null -eq $obj) {
        return "Null"
    }
    
    $type = $obj.GetType()
    
    while($type -ne $null)
    {
        $ret += "$($delimiter)$($type.ToString())"
        $type = $type.BaseType
    }
    
    return $ret
}