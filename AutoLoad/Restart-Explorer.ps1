function Restart-Explorer()
{
    get-process explorer | %{$_.kill()}
    # read-host
    # explorer
}