# Helper function to save duplication
function New-AliasInProfile($Name, $Value) {
    if(test-path Alias:$Name)
    {
        del Alias:$Name
    }
    
    New-Alias @args @PSBoundParameters -ErrorAction SilentlyContinue -scope Global
}
function Get-HelpWithLess
(
    $Name,
    $Category,
    $Component,
    $Functionality,
    $Path,
    $Role,
    [switch] $Detailed,
    [switch] $Full,
    [switch] $Examples,
    [switch] $Online
)
{
    (Get-Help @psboundparameters) | less
}

function Get-HelpWithLessDetailed
(
    $Name,
    $Category,
    $Component,
    $Functionality,
    $Path,
    $Role,
    [switch] $Full,
    [switch] $Examples,
    [switch] $Online
)
{
    (Get-Help @psboundparameters -detailed) | less
}

New-AliasInProfile help Get-HelpWithLess
New-AliasInProfile helpd Get-HelpWithLessDetailed
New-AliasInProfile new New-Object
# So we can reload profile just by typing '. p'
New-AliasInProfile p ($profile)