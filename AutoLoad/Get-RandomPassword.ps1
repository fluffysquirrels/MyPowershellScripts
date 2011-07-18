function Get-RandomPassword() {
    $rand = New-Object System.Random
    
    $length = 10
    $characters = @(1..$length |
        % { [string][char]$rand.next(33,127) })
        
    return [String]::Join("", $characters)
}

