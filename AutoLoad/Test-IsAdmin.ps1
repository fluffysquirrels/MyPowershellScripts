function Test-IsAdmin()
{
    $id = [System.Security.Principal.WindowsIdentity]::GetCurrent()
    $wp = new-object System.Security.Principal.WindowsPrincipal($id)
    $admin = [System.Security.Principal.WindowsBuiltInRole]::Administrator
    return $wp.IsInRole($admin)
}