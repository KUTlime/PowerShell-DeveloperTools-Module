@{
    RootModule        = 'DeveloperTools'
    ModuleVersion     = '1.1.0'
    GUID              = 'd3bb84fb-6594-44f5-b2e0-ad08fde65b93'
    Author            = 'Radek Zahradník'
    CompanyName       = 'Radek Zahradník'
    Copyright         = '(c) 2021 Radek Zahradník. All rights reserved.'
    Description       = 'A collection of tools used to make a daily life of C# .Net developer easier.'
    FunctionsToExport = @('Open-DevToolsConfiguration','Set-DevToolsConfiguration', 'Set-RepoLocation', 'Clear-BuildWorkspace', 'Clear-Repo', 'Clear-LocalBranch')
    AliasesToExport   = '*'
    FileList          = @('configuration.json')
    PrivateData       = @{
        PSData = @{
            ReleaseNotes = @'
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