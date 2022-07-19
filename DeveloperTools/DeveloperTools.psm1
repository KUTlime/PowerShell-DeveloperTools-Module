$configurationFileName = 'configuration.json'
[System.IO.FileInfo]$configurationFilePath = Join-Path -Path $PSScriptRoot -ChildPath $configurationFileName

try
{
    $configurationValue = [System.IO.File]::ReadAllText($configurationFilePath.FullName) | ConvertFrom-Json
    New-Variable -Name 'configuration' -Value $configurationValue -Scope 'Script'
}
catch
{
    Write-Error 'The configuration file has not been found. Execute Set-DevToolsConfiguration -Default'
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
        [Parameter(Mandatory, ParameterSetName = 'DefaultConfig')]
        [Switch]
        $Default,
        [Parameter(Mandatory, ParameterSetName = 'StringConfig')]
        [string]
        $Configuration
    )

    if ($Default)
    {
        $setup = @{
            RepoFolders = @{
                Path          = Join-Path -Path $env:USERPROFILE -ChildPath 'source'
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
    $path = $configuration.RepoFolders.GetEnumerator() |
    Where-Object { $_.EnumValueName -eq $Repository } |
    Select-Object -ExpandProperty 'Path'
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
        Get-ChildItem -Path "$($Path.Path)" -Include 'bin', 'obj', 'packages' -Directory -Recurse -Force | Remove-Item -Recurse -Force -ErrorAction:Stop
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
        $configuration.RepoFolders.GetEnumerator() |
        Where-Object { $_.EnumValueName -eq $Repository } |
        Select-Object -ExpandProperty 'Path' |
        Clear-BuildWorkspace
    }
}

function Clear-LocalBranch
{
    [Alias('clearbranch')]
    [Alias('clb')]
    [OutputType([void])]
    param (
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Repo')]
        [Repo]
        $Repository = 'Default',
        [Parameter(ValueFromPipeline, ValueFromPipelineByPropertyName, ParameterSetName = 'Path')]
        [System.Management.Automation.PathInfo]
        $Path = $PWD
    )
    process
    {
        $originPwd = $PWD
        $targetPath = $configuration.RepoFolders.GetEnumerator() |
        Where-Object { $_.EnumValueName -eq $Repository } |
        Select-Object -ExpandProperty 'Path'
        $targetPath ??= $Path
        Set-Location $targetPath
        git fetch
        git branch -vv | Select-String -Pattern ': gone]' | ForEach-Object { ($_ -split '\s+')[1] } | ForEach-Object { git branch -D $_ }
        Set-Location -Path $originPwd
    }
}

