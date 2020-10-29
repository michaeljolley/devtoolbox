function Restore-WorkspacePackages {
  <#
    .SYNOPSIS
    Restore NPM, Nuget, and/or Libman packages within this directory or sub-directories

    .PARAMETER NPM
    Restore NPM packages

    .PARAMETER Nuget
    Restore Nuget packages

    .PARAMETER Libman
    Restore Libman packages
  #>
  [Alias('rwp')]
  [CmdletBinding(DefaultParameterSetName = "Default")]
  param(
    [Parameter(ParameterSetName = "NPM", HelpMessage = "Restore only NPM packages")]
    [switch]$NPM,
    [Parameter(ParameterSetName = "Nuget", HelpMessage = "Restore only Nuget packages")]
    [switch]$Nuget,
    [Parameter(ParameterSetName = "Libman", HelpMessage = "Restore only Library Manager packages")]
    [switch]$Libman
  )

  $restoreNpm = -not ($null -eq (Get-Command npm -ErrorAction SilentlyContinue))
  $restoreDotnet = -not ($null -eq (Get-Command dotnet -ErrorAction SilentlyContinue))
  $restoreLibman = -not ($null -eq (Get-Command libman -ErrorAction SilentlyContinue))

  if ($restoreNpm -and ($PSCmdlet.ParameterSetName -eq "Default" -or $PSCmdlet.ParameterSetName -eq "NPM")) {
    Write-Host "Restoring NPM packages"
    Get-ChildItem -Filter package.json -Recurse | Where-Object Directory -NotLike "*node_module*" | ForEach-Object {
      Write-Host "-  Restoring $($_.Directory)..." -ForegroundColor Yellow
      Push-Location $_.Directory
      npm install --no-save
      Pop-Location
    }
  }

  if ($restoreDotnet -and ($PSCmdlet.ParameterSetName -eq "Default" -or $PSCmdlet.ParameterSetName -eq "Nuget")) {
    Write-Host "Restoring NuGet packages"
    Get-ChildItem -Filter *.*proj -Recurse | ForEach-Object {
      Write-Host "-  Restoring $($_.Directory)..." -ForegroundColor Yellow
      Push-Location $_.Directory
      dotnet restore
      Pop-Location
    }
  }

  if ($restoreLibman -and ($PSCmdlet.ParameterSetName -eq "Default" -or $PSCmdlet.ParameterSetName -eq "Libman")) {
    Write-Host "Restoring Libman packages"
    Get-ChildItem -Filter libman.json -Recurse | ForEach-Object {
      Write-Host "-  Restoring $($_.Directory)..." -ForegroundColor Yellow
      Push-Location $_.Directory
      libman restore
      Pop-Location
    }
  }
}