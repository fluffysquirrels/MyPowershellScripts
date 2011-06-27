function Push-Set-Location
(
    [string] $LiteralPath,
    [switch] $PassThru,
    [switch] $UseTransaction
)
{
    Push-Location
    Set-Location @PsBoundParameters
}
