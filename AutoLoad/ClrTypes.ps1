function Get-Type
{
    [AppDomain]::CurrentDomain.GetAssemblies() | %{$_.GetModules()} | %{$_.FindTypes($null, $null)}
}
function Find-Type($wildcardPattern, $regex)
{
    if($wildcardPattern -ne $null)
    {
        $types = get-type | ?{$_.FullName -like $wildcardPattern}
    }
    elseif ($regex -ne $null)
    {
        $types = get-type | ?{$_.FullName -match $regex}
    }
    else
    {
        throw "Neither wildcard pattern nor regex supplied to Find-Type."
    }
    
    return $types | sort FullName | ft FullName
}