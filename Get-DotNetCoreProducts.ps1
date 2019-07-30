#Requires -Version 3.0
Param ()

#Host consists of Runtime, Host and Host FX Resolver
$Products = @('Microsoft .NET Core Runtime -*',
              'Microsoft .NET Core Host -*', 
              'Microsoft .NET Core Host FX Resolver -*',
              'Microsoft .NET Core SDK*',
              'Microsoft ASP.NET Core*')
$Products | ForEach-Object {
    $Product = $_
    #Get all installed apps from Registry matching .Net Core SDK
    Get-ItemProperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*'  | 
        Where-Object {$_.displayname -like $Product} | 
        Sort-Object { [System.Version]::new($_.DisplayVersion)} -Descending | 
        Select-Object DisplayName, DisplayVersion, UninstallString 
}
#Best viewed with .\Get-DotNetCoreProducts.ps1 | FT -autosize 
