$filter = "Microsoft .NET Core"
$app = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Get-ItemProperty |
        Where-Object {$_.DisplayName -match $filter } |
        Select-Object DisplayName, DisplayVersion, Publisher, InstallDate, QuietUninstallString, UninstallString 
$app
$app | %{ if ($_QuietUninstallString -eq $null ) { $_.UninstallString} else { $_._UninstallString} }  | %{ if ($_ -ne $null ) {& cmd /c $_ /quiet /norestart} }  
