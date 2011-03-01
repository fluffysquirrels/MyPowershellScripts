Add-Type -AssemblyName System.Web

function Get-ScheduledTasks-HtmlReport($tasks)
{
    $columns =  "Machine",
                "Enabled",
                "Command",
                "Arguments",
                "LastRunTime",
                "NextRunTime",
                (Get-TextAreaColumn "Xml")
    
Write-Output @"
    <html>
    <head>
        <link rel='stylesheet' type='text/css' href='assets/main.css'></link>
        
        <script type='text/javascript' src='assets/js/jquery.1.5.1.min.js'></script>
        <script type='text/javascript' src='assets/js/jquery.tablesorter.min.js'></script>
        
        <script type='text/javascript'>
            `$(document).ready(function() 
            { 
                `$('#results').tablesorter(); 
                `$('textarea').click(function(){ this.focus(); this.select(); })
            });
        </script>
    </head>
    <body>
        <table id='results'>
            <thead>
                <tr class='header'>
"@
                foreach($col in $columns)
                {
Write-Output @"
                    <th>$col</th>
"@
                }
Write-Output @"
                </tr>
            </thead>
            
            <tbody>
"@

            foreach($task in $tasks)
            {
                if($task -eq $null)
                { 
                    continue;
                }

Write-Output @"
                <tr>
"@
                foreach($col in $columns)
                {
                    $value = Get-ColumnValueHtml $task.$col $col
Write-Output @"
                    <td>$value</td>
"@
                }
Write-Output @"
                </tr>
"@
            }
            
            
Write-Output @"
            </tbody>
        </table>
    </body>
    </html>
"@
}


function Get-ColumnValueHtml($value, $col)
{
    if($col.DisplayType -eq "TextArea")
    {
        return "<textarea>$(Encode-Html $value)</textarea>"
    }
    
    $rv = ""
    
    if($value -is "DateTime")
    {
        $rv = $value.ToString("yyyy/MM/dd HH:mm:ss")
    }
    else
    {
        $rv = $value
    }
    
    return Encode-Html $rv
}

function Get-TextAreaColumn($columnName)
{
    $col = [psobject] $columnName
    
    add-member -in $col NoteProperty "DisplayType" "TextArea"
    
    return $col
}

function Encode-Html($s)
{
    return [System.Web.HttpUtility]::HtmlEncode($s)
}