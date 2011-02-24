function Extract-Zip
{
	param([string]$zipfilename, [string] $destination)

	$zipfilename = convert-path $zipfilename

	if(test-path($zipfilename))
	{	
		if((test-path($destination)) -eq $false)
		{
			new-item -itemtype "directory" $destination 
		}

		$destination = convert-path $destination
		$shellApplication = new-object -com shell.application
		$zipPackage = $shellApplication.NameSpace($zipfilename)
		$destinationFolder = $shellApplication.NameSpace($destination)
		$destinationFolder.CopyHere($zipPackage.Items())
	}
}

#Copy fuse changes from "\\tsclient\c\tss" on the terminal services client to the local machine and unzip them to 
# c:\tss\changes (the staging area)
#
#ffce = FUSE fast copy and extract
function ffce
{
	cd \
	cd tss
	del changes.zip
	cp \\tsclient\c\tss\changes.zip changes.zip;
	rm -r -force changes;
	extract-zip changes.zip changes;
    $postfix = GetConfigStringsPostfixForLocalMachine;
    del changes\Fusev2\ConfigFiles\AppSettings.config
    del changes\Fusev2\ConfigFiles\ConnectionStrings.config
    cp "changes\Fusev2\ConfigFiles\AppSettings.$postfix.config" changes\Fusev2\ConfigFiles\AppSettings.config
    cp changes\Fusev2\ConfigFiles\ConnectionStrings.$postfix.config changes\Fusev2\ConfigFiles\ConnectionStrings.config
}
function GetConfigStringsPostfixForLocalMachine
{
	switch([Environment]::MachineName)
    {
        "SPIKY" { "dev" }
        "ALTA-DEV-SERVER" { "demo" }
        "CCSDC7MW010" {"live"}
    }
}
#Copy changes from the staging area to the FUSE application folder
# ffd = FUSE fast deploy
function ffd
{
	cp -r c:\tss\changes\* c:\inetpub\fusev2
}
# Copy fuse changes to local machine, unzip them, then copy into c:\inetpub\fusev2
# ffced = FUSE fast copy, extract, and deploy.
function ffced
{
	ffce
	ffd
}