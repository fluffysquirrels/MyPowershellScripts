function Fetch-AllGitSvn
(
    $gitProjectsRoot = (Get-GitProjectsPath)
)
{
    $projectsToFetch = gci -recurse -force $gitProjectsRoot | ?{$_.name -eq ".git"} | %{$_.parent}
    foreach($project in $projectsToFetch)
    {
        $path = $project.fullname
        Write-Host "Fetching $path"
        cd $path
        git svn fetch
    }
}

function Get-GitProjectsPath() {
    $pcName = $env:computername
    $rv = ""
    
    switch($pcName) {
        $MachineName_Work    { $rv = "D:\Projects\Git" }
        "BEAST"     { $rv = "c:\Data\Code\Parker Fox\Git" }
        default     { throw "Unrecognised computer name '$pcName'" }
    }
    
    return $rv
}