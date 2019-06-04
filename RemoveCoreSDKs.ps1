[CmdletBinding()]
    param (
        $DisplayName = "Microsoft .NET Core SDK"
    )

    $VerbosePreference = "Continue"

    $apps = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | `
    Where-Object { $_.DisplayName -match $DisplayName } 

    foreach ($app in $apps) {

        $exepath = $app.QuietUninstallString.Substring(1, $app.QuietUninstallString.LastIndexOf("`"")-1)
        $exeargs = $app.QuietUninstallString.Substring($app.QuietUninstallString.LastIndexOf("`"")+2)

        if (Test-Path $exepath) {

            Write-Verbose "Uninstalling $($app.DisplayName)..."
            Start-Process -FilePath $exepath -ArgumentList $exeargs -Wait -NoNewWindow -PassThru
        }
    }
