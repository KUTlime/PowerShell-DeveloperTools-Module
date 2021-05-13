$configurationFileName = 'configuration.json'
[System.IO.FileInfo]$configurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath $configurationFileName

try
{
    $configuration = [System.IO.File]::ReadAllText($configurationFilePath.FullName) | ConvertFrom-Json
}
catch
{
    Write-Error "The configuration file has not been found. Execute Set-DevToolsConfiguration -Default"
}

$HereString =
@"
// very simple enum type
public enum Repo
{
    `n$(foreach ($folder in $configuration.RepoFolders){"`t$($folder.EnumValueName)`,"})`n
}
"@
Write-Verbose $HereString
Add-Type -TypeDefinition $HereString

function Open-DevToolsConfiguration
{
    [Alias('odvconfig')]
    [OutputType([void])]
    param()
    Start-Process -FilePath $configurationFilePath.FullName
}

function Set-DevToolsConfiguration
{
    [CmdletBinding()]
    [Alias('dtconfig')]
    [OutputType([void])]
    param(
        [Parameter(Mandatory,ParameterSetName='DefaultConfig')]
        [Switch]
        $Default,
        [Parameter(Mandatory,ParameterSetName='StringConfig')]
        [string]
        $Configuration
    )

    if ($Default)
    {
        $setup = @{
            RepoFolders = @{
                Path = Join-Path -Path $env:USERPROFILE -ChildPath 'source'
                EnumValueName = 'Default'
            }
        }
        $configuration = $setup | ConvertTo-Json
    }
    if (Test-Path -Path $configurationFilePath)
    {
        Write-Warning "The configuration file already exist in the path $configurationFilePath"
        Rename-Item -Path $configurationFilePath.FullName -NewName ($configurationFilePath.FullName + '_old') -Force
    }
    $configuration | Out-File -FilePath $configurationFilePath -Encoding:unicode -Force
}

function Set-RepoLocation
{
    [Alias('slr')]
    [OutputType([void])]
    [CmdletBinding()]
    param (
        [Repo]
        $Repository = 'Default'
    )
    $path = $configuration.RepoFolders | Where-Object {$_.EnumValueName -eq $Repository} | Select-Object -ExpandProperty 'Path'
    Set-Location -Path $path
}

function Clear-BuildWorkspace
{
    [Alias('clearbs')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [System.Management.Automation.PathInfo]
        $Path = $PWD
    )
    process
    {
        Write-Host "Cleaning up build workspace by removing bin, obj and package directory in $($Path.Path)"
        Get-ChildItem -Path "$($Path.Path)" -Include 'bin','obj','packages' -Directory -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction:Stop
        Write-Host 'Clean up was successful' -ForegroundColor Green
    }
}

function Clear-Repo
{
    [Alias('clearrepo')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Repo]
        $Repository = 'Default'
    )
    process
    {
        $configuration.RepoFolders |
        Where-Object {$_.EnumValueName -eq $Repository} |
        Select-Object -ExpandProperty 'Path' |
        Clear-BuildWorkspace
    }
}

