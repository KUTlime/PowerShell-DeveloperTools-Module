@{
    RootModule        = 'DeveloperTools'
    PowerShellVersion = '7.3.3'
    ModuleVersion     = '1.3.0'
    GUID              = 'd3bb84fb-6594-44f5-b2e0-ad08fde65b93'
    Author            = 'Radek Zahradník'
    CompanyName       = 'Radek Zahradník'
    Copyright         = '(c) 2021 Radek Zahradník. All rights reserved.'
    Description       = 'A collection of tools used to make a daily life of C# .Net developer easier.'
    FunctionsToExport = @('Open-DevToolsConfiguration','Set-DevToolsConfiguration', 'Set-RepoLocation', 'Clear-BuildWorkspace', 'Clear-Repo', 'Clear-LocalBranch', 'Restart-AzureCosmosDbEmulator', 'Measure-Repo')
    AliasesToExport   = '*'
    FileList          = @('configuration.json')
    PrivateData       = @{
        PSData = @{
            ReleaseNotes = @'
v1.3.0: (2022-10-27)
- Measure-Repo
- Add compatibility with PowerShell 7.3.3 restriction

v1.2.0: (2022-12-12)
- Added Restart-AzureCosmosDbEmulator

v1.1.0: (2022-07-07)
- Added Clear-LocalBranch
- Changed Set-RepoLocation
- Code style fixes

v1.0.0: (2020-05-13)
- Clear-Repo & Clear-BuildWorkspace
- Set-Repo
'@

        }
    }
}