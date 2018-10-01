$app = Get-WmiObject -Class Win32_Product | Where-Object { 
    $_.Name -match "Microsoft .NET Core SDK" 
}

#Keep latest
$app | Sort-Object { [System.Version]::new($_.Version)} -Descending | 
    Select-Object -First  1 | ForEach-Object { 
        Write-Host ("Keeping " + $_.Name + " version " + $_.Version)
    }

#Convert WMI version to System.version, sort decending, skip latest 
$app | Sort-Object { [System.Version]::new($_.Version)} -Descending | 
    Select-Object -Skip 1 | 
        ForEach-Object { 
            Write-Host ("*** Removing  " + $_.Name + " version " + $_.Version + " IdentifyingNumber: " + $_.IdentifyingNumber)
            pushd $env:SYSTEMROOT\System32
            Start-Process msiexec -wait -ArgumentList ("/x " + $_.identifyingnumber + " /qn IGNOREDEPENDENCIES=ALL")
            popd
        }
