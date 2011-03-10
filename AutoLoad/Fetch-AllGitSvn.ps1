function Fetch-AllGitSvn()
{
    $gitProjectsRoot = "D:\Projects\Git"
    $projectsToFetch = gci $gitProjectsRoot | ?{$_.psiscontainer -and $_.name -ne "LoanBookUK - broken"} 
    foreach($project in $projectsToFetch)
    {
        $path = $_.fullname
        Write-Host "Fetching $path"
        cd $path
        git svn fetch
    }
}