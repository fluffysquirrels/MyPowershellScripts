function Get-Assembly
(
    [Parameter(ValueFromPipeline = $true)]
    [string]
    # Accepts wildcards.
        $name
)
{
    begin
    {
        if([String]::IsNullOrEmpty($name)) {
            return [appdomain]::CurrentDomain.GetAssemblies()
        }
    }
    process
    {
        if(!([String]::IsNullOrEmpty($name))) {
            $foundAssembly =
                Get-Assembly |
                    ?{ $_.GetName().Name -like $name }
            
            if($foundAssembly -eq $null) {
                throw "Couldn't find a loaded assembly matching '$name'"
            }
            
            return $foundAssembly
        }
    }
}