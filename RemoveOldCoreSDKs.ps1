$app = Get-CimInstance -ClassName Win32_Product -Filter 'Name like "%.NET Core SDK%"' -Property Name,Version,IdentifyingNumber

$app = $app | Add-Member -MemberType ScriptProperty -Name MajorVersion -Value { [int]$this.Version.Split(".")[0] } -PassThru
$app = $app | Add-Member -MemberType ScriptProperty -Name MinorVersion -Value { [int]$this.Version.Split(".")[1] } -PassThru
$app = $app | Add-Member -MemberType ScriptProperty -Name PatchVersion -Value { [int]$this.Version.Split(".")[2] } -PassThru
$app = $app | Sort-Object -Property MajorVersion,MinorVersion,PatchVersion

$latest = $app | Select-Object -Last 1

$app | Where-Object {$_ -ne $latest} | ForEach-Object {
    Write-Host "Removing: $($_.Name)"

    Start-Process msiexec -wait -ArgumentList "/x $($_.IdentifyingNumber)"
}

Write-Host "Preserving: $($latest.Name)"