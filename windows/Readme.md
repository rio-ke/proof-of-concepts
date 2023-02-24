
_schedule the docs_

```ps1
$Action = New-ScheduledTaskAction -Execute 'pwsh.exe' -Argument '-NonInteractive -NoLogo -NoProfile -File "C:\scripts\crlupdate.ps1"'
$Trigger = New-ScheduledTaskTrigger -Once -At 9am
$Settings = New-ScheduledTaskSettingsSet
$Task = New-ScheduledTask -Action $Action -Trigger $Trigger -Settings $Settings
Register-ScheduledTask -TaskName 'CRlUpdate' -InputObject $Task -User 'username' -Password 'passhere'
Get-ScheduledTask -TaskName 'CRlUpdate'
```
