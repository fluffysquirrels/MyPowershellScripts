function Apply-Patches($patches)
{
    $patches | %{Apply-Patch $_}
}

function Apply-Patch($patch)
{
    $subPrefix = "Subject: *"
    $subjectLine = gc $patch | ?{$_ -like $subPrefix}
    $subject = $subjectLine.SubString($subPrefix.Length - 1)
    
    git apply $patch.FullName
    
    git add .
    git add -u .
    
    git commit -m "$subject"
}
