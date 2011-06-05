function Select-Chunk($chunkSize = 10)
{
    begin
    {
        $iGotNothing = $true
        $buffer = @()
    }
    process
    {
        $iGotNothing = $false
        $buffer += $_
        if($buffer.Length -ge $chunkSize) {
            ,($buffer)
            $buffer = @()
        }
    }
    end
    {
        if($buffer.Length -ge 0 -or
            $iGotNothing) {
            ,$buffer
        }
    }
}