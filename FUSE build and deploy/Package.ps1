cd \inetpub\fusev2

#Directory tree copying

function Get-DirectoryFromFilename {
$die = $args[0] -match "([^\\/]*[\\/])*"
return $matches[0]
}
function Ensure-DirectoryForFilename
($fn) 
{
    $dir = Get-DirectoryFromFilename($fn)
    if(!(test-path ($dir)))
    {
        new-item -type "directory" ($dir) | out-null
    }
}

function Copy-FileListPreservingTree
{
$listfn = $args[0]
$todir = $args[1]
foreach ($fn in get-content $listfn | where {$_ -ne ""}) {
$copyfn = ("{0}\{1}" -f $todir, $fn)
ensure-directoryforfilename $copyfn
copy $fn $copyfn
}
}

function Fuse-EnsureBuild
{
    $fnLog = "c:\inetpub\fusev2\buildlog.txt"
    if (test-path $fnLog) {del $fnLog}
    
    write-host "Building..."
    
    & "C:\Program Files\Microsoft Visual Studio 9.0\Common7\IDE\vwdexpress.exe" /out $fnLog "c:\inetpub\fusev2\fusev2\fusev2.vbproj" /build | out-null

    $buildSucceeded = $false
    get-content $fnLog | % {
        if ($_ -match "========== Build: \d* succeeded or up-to-date, 0 failed, \d* skipped ==========")
        {
            $buildSucceeded = $true;
        }
    }
    write-host ("`$buildSucceeded = $buildSucceeded" -f $buildSucceeded);
    if ($buildSucceeded) {
        del $fnLog;
    }
    return $buildSucceeded;
}

function Copy-FuseChanges
{
Copy-FileListPreservingTree changes.txt changes

#Ensure build
$rvBuild = fuse-ensureBuild
if ($rvBuild -eq $false) { 
get-content buildlog.txt | write-host
return $false 
}

#Copy binaries

new-item -type "directory" "changes\Fusev2\bin"
copy fusev2\bin\fusev2.dll changes\fusev2\bin\fusev2.dll
copy fusev2\bin\fusev2.pdb changes\fusev2\bin\fusev2.pdb

cd fusev2/static/css
./mergecss.bat
cd ../../..

$cssPath = "changes\fusev2\static\css"
if(!(test-path($cssPath))) {new-item -type "directory" $cssPath}
copy fusev2\static\css\pfcp_merged.css changes\fusev2\static\css\pfcp_merged.css
}

function Compress-FuseChanges
{
$rvCopyChanges = copy-fusechanges
write-host "`$rvCopyChanges = $rvCopyChanges"
if ($rvCopyChanges -eq $false) { 
    write-host  "Compress-FuseChanges failed"
    return $false
}
if (test-path changes.zip) {del changes.zip}
cd changes
# &"c:\program files\winrar\rar" a -r ..\changes.zip .
&"..\scripts\zip" -r "..\changes" . -i * > ..\ziplog.txt
cd ..
if (test-path ziplog.txt) {del ziplog.txt}

#ls -r changes | out-zip changes.zip
}

function Exec-FuseGitCommand([string] $gitCommand)
{
    $fnResult = "fuseCmdResult.txt";
    if (test-path $fnResult) { rm $fnResult ;}
	$myCommand = "`"/c `"pushd `"C:\Inetpub\Fusev2`" && `"C:\Program Files\Git\bin\sh.exe`" --login -c `"{0} > $fnResult`"" -f $gitCommand;
	write-host $mycommand;
	cmd $myCommand > $null;
    
    $result = gc $fnResult;
    
    rm $fnResult;
    return $result;
}

# ffp = FUSE fast package.
# This: 
# 1. Builds the FUSEv2 solution (incl merging the CSS files)
# 2. Works out what files have changed with these sources:
#   a) what's changed between the optional Git commits in the parameter $changesTreeish
#   b) in the Git index
#   c) between the working tree and what's currently in the Git index
# 3. Zips up the files that have changed, and the built binaries, and the merged CSS
# 4. Copies that zip file to C:\tss, ready to pulled onto a server by the deployment script on the server, via a Terminal Services connection.

function ffp
([string] $changesTreeish = "")
{
	if(test-path changes.txt) {del changes.txt}
	if(test-path changes.txt`') {del changes.txt`'}

    if ($changesTreeish -ne "")
    {
        $gitCommand = 'git log --name-only --pretty="format:" {0}' -f $changesTreeish;
        Exec-FuseGitCommand($gitCommand) > changes-betweenCommits.txt;
        gc changes-betweenCommits.txt >> changes.txt;
        "" >> changes.txt;
    }
    Exec-FuseGitCommand('git diff --name-only') > changes-inWorkingTree.txt;
    Exec-FuseGitCommand('git diff --staged --name-only') > changes-inIndex.txt;

    gc changes-inWorkingTree.txt >> changes.txt;
    "" >> changes.txt;
    gc changes-inIndex.txt >> changes.txt;
    
    $rvCompressChanges = compress-fusechanges;
    write-host "`$rvCompressChanges = $rvCompressChanges";
	if ($rvCompressChanges -eq $false) { 
        write-host "Operation failed";
        return;
    }
	
	rm -r changes

	mv changes*.txt c:\tss -force
	mv changes.zip c:\tss\changes.zip -force
}