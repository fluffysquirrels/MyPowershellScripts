function Get-Type
{
    [AppDomain]::CurrentDomain.GetAssemblies() | %{$_.GetModules()} | %{$_.FindTypes($null, $null)}
}