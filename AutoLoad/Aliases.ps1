# Helper function to save duplication
function New-AliasInProfile() {
    New-Alias @args -ErrorAction SilentlyContinue -scope Global
}
function Get-HelpWithLess() {
    (Get-Help @args) | less
}

# So we can reload profile just by typing '. p'
New-AliasInProfile p ($profile)
New-AliasInProfile help Get-HelpWithLess
New-AliasInProfile l less
New-AliasInProfile new New-Object