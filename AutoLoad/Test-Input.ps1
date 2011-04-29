function Test-Input
(
    $path,
    [switch] $NabInput
) {
    begin {
        function Write-Path() {
            "`$path = '$path'"
        }
        
        Write-Host "Main before"
        Write-Path
        
        Write-Host "Begin"
        Write-Path

    }
    # process {
    #     Write-Host "Process '$_'"
    # }
    end {
        Write-Host "End"
        "`$Input:"
        $Input | ft name
        Write-Host "---End of input"
    }
}