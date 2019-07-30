#Requires -Version 3.0
#Requires -RunAsAdministrator
[CmdletBinding(SupportsShouldProcess=$true)]
Param ()

#Function to remove a single version of dotnetCore - supports -whatif
Function Remove-DotNetCore {
    [CmdletBinding(SupportsShouldProcess=$true)]
    param ([string] $GUID )

    if ($PSCmdlet.ShouldProcess($GUID)) {
        pushd $env:SYSTEMROOT\System32
        Start-Process msiexec -wait -ArgumentList ("/x $GUID /qn IGNOREDEPENDENCIES=ALL")
        popd
    }
}

#Get all installed apps from Registry matching .Net Core SDK
$DotNetCoreSDKInstalls = Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'  | 
         Where-Object {$_.displayname -match 'Microsoft .NET Core SDK'} | 
         Select-Object DisplayName, DisplayVersion, UninstallString 


#Keep latest
$DotNetCoreSDKInstalls | Sort-Object { [System.Version]::new($_.DisplayVersion)} -Descending | 
    Select-Object -First  1 | ForEach-Object { 
        Write-Host ("Keeping " + $_.DisplayName + " version " + $_.DisplayVersion)
    }

#Convert WMI version to System.version, sort decending, skip latest 
$DotNetCoreSDKInstalls | Sort-Object { [System.Version]::new($_.DisplayVersion)} -Descending | 
    Select-Object -Skip 1 | 
        ForEach-Object { 
            $IdentifyingNumber = "{" + $_.UninstallString.split("{")[1]
            Write-Host ("*** Removing  " + $_.DisplayName + " version " + $_.DisplayVersion + " Uninstall: " + $_.UninstallString)
            Remove-DotNetCore -GUID $IdentifyingNumber
        }
