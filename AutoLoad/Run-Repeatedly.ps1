function Run-Repeatedly($scriptBlock, $pollIntervalSeconds = 1, $iterations = 1000)
{
    1..$iterations | % {
        & $scriptBlock
        Start-Sleep -Seconds $pollIntervalSeconds
    }
}