function Get-MasterPage($page) {
    $text = Get-Text $page;
    
    $hasMasterPage = $text -match 'MasterPageFile="(?<masterPageFile>[^"]+)"'
    
    if(!$hasMasterPage) {
        return $null
    }
    
    # $hasMasterPage = $true
    
    $masterPageFile = $matches.masterPageFile
    
    return $masterPageFile
}

function Get-MasterPages
(
    [string] $path,
    [switch] $pretty = $true
) {
    $path = Convert-Path $path

    $pages = gci -recurse $path -filter *.aspx

    $pages = $pages |
        % {
            $page = [PSObject]::AsPSObject($_)
            
            $masterPageFile = Get-MasterPage $page
            $relativePath = $page.FullName.Substring($path.Length + 1)
            

            Add-Member -in $page NoteProperty "MasterPageFile"    $masterPageFile
            Add-Member -in $page NoteProperty "RelativePath"      $relativePath
            
            Write-Output $page
        }

    if($pretty) {
        $pages | sort MasterPageFile, RelativePath | ft MasterPageFile, RelativePath -auto
    }
    else {
        return $pages
    }
}

Get-MasterPages  "D:\Projects\SVN\LoanBookUK\LB-3653_Server_Name_In_LMS_Header\LMS" -pretty

