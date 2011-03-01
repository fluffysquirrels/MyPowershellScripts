function ScheduledTasks-HtmlTest()
{
    $ts = Get-ScheduledTasks;
    $t = $ts[1];
    
    $fts = $ts | ?{$_.Command -match "GoogleUpdate|WLTRAY|Everything"}
    
    $html = Get-ScheduledTasks-HtmlReport $fts;
    $html > "C:\Users\Alex\Documents\WindowsPowerShell\AutoLoad\ScheduledTasks\report.html"
}