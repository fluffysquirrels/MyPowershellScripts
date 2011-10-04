[reflection.assembly]::loadwithpartialName("microsoft.web.administration") | Out-Null

function Connect-IIS($server)
{
    return [Microsoft.Web.Administration.ServerManager]::OpenRemote($server)
}
