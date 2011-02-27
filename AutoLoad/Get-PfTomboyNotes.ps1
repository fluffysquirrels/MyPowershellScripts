function Get-PfTomboyNotes()
{
    gci "c:\users\alex\appdata\roaming\tomboy\notes\*.note" | 
        ?{ $noteText = ([system.io.file]::readalltext($_))
           $noteText -match "system:notebook:Parker Fox"}
}