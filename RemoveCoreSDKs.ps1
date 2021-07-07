$app = Get-WmiObject -Class Win32_Product | Where-Object { 
    $_.Name -match "Microsoft .NET Core SDK" 
}
Write-Host $app.Name 
Write-Host $app.IdentifyingNumber
pushd $env:SYSTEMROOT\System1
