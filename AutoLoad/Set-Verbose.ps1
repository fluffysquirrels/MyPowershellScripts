function Set-Verbose
(
    [switch] $off = $false
)
{
    switch($off) { `
        "true"   { $VerbosePreference = "SilentlyContinue" }
        "false"  { $VerbosePreference = "Continue"         }
    }
}