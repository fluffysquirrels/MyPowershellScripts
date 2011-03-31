function Fetch-AllGitSvn
(
    $gitProjectsRoot = (Get-GitProjectsPath)
)
{
    $projectsToFetch = gci $gitProjectsRoot | ?{$_.psiscontainer} 
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
        "BUNGLE"    { $rv = "D:\Projects\Git" }
        "BEAST"     { $rv = "c:\Data\Code\Parker Fox\Git" }
        default     { throw "Unrecognised computer name '$pcName'" }
    }
    
    return $rv
}