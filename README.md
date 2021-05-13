# PowerShell DeveloperTools Module

> A PowerShell module to make life of .NET developer easier.

## What this module can do for you?

* Easily navigate between repositories
* Proper repository clean up
* Proper working directory clean up

## How to install

Run PowerShell console with an elevated privileges (_as admin_) and execute this command:

```powershell
Install-Module 'DeveloperTools' -Scope CurrentUser -Force -PassThru | Import-Module; Open-DevToolsConfiguration
```

This will:

* Install the module to your user profile
* Import the module to the current session
* Open module setting, see section below

## Module settings

The commands `Clear-Repo`, `Set-RepoLocation` are using `Repo` enum to specify the target path. This enum is dynamically generated based on your settings when the module is loaded.

This is a default settings. You can customize the path to whatever you like, a value `Default` is mandatory.

```json
{
    "RepoFolders": [
        {
            "Path": "C:\\Users\\radek\\source\\",
            "EnumValueName" : "Default"
        }
    ]
}
```

If you want navigate between repositories easily, specify the paths into this configuration json. See this example:

```json
{
    "RepoFolders": [
        {
            "Path": "C:\\Users\\radek\\source\\myproject\\",
            "EnumValueName" : "Default"
        },
        {
            "Path": "C:\\Users\\radek\\source\\myemployeeproject\\",
            "EnumValueName" : "mews"
        }
        ,
        {
            "Path": "C:\\Users\\radek\\source\\openhere\\",
            "EnumValueName" : "openhere"
        }
    ]
}
```

## Module auto loading

If you want to have the DeveloperTools module available every single time when you run a specific PowerShell console host, open the host an execute this command:

```powershell
@"
try
{
  Set-ExecutionPolicy Bypass -Scope Process
  Import-Module -Name DeveloperTools
}
catch
{
  'Powershell is running in non-administrator mode.'
}
"@ | Out-File $profile -Append
```

## All available commands

```powershell
Get-Command -Module DeveloperTools
```
