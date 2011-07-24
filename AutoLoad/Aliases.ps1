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

New-Alias -force    fs              Format-String
New-Alias -force    gt              Get-Text
New-Alias -force    help            Get-HelpWithLess
New-Alias -force    helpd           Get-HelpWithLessDetailed
New-Alias -force    l               less
New-Alias -force    new             New-Object
# So we can reload profile just by typing '. p'
New-Alias -force    p               ($profile)
New-Alias -force    ??              Coalesce-Args
New-Alias -force    wr              Where-Regex
