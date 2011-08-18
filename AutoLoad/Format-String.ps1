function Format-String
(
    [Parameter(ValueFromPipeline = $true)]
    $inputObject
)
{
    process
    {
        return $inputObject.ToString()
    }
}