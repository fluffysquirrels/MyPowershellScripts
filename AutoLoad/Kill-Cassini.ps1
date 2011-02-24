function Kill-Cassini() {
    Get-Process webdev* | %{$_.kill()}
}
