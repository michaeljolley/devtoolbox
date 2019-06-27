<#
  .SYNOPSIS
  Changes your current directory to the directory of the project you provide.
  
  .DESCRIPTION
  This function will search the root directory (or the current directory if
  no root directory is set in the environment variables) recursively for the project
  directory you provided. If multiple directories are found, a menu will prompt for the
  directory to use.

  .PARAMETER Project
  The project to search for and change to when found.

  .PARAMETER SetRootLocation
  Allows you to set the root location.

  .PARAMETER RootLocation
  The root location to set.

  .PARAMETER GetRootLocation
  Returns the root location that is currently set.

  .PARAMETER SetSearchDepth
  Allows you to set the search depth for child-directories (projects).

  .PARAMETER Depth
  The depth of child-directories to search in.

  .PARAMETER GetSearchDepth
  Returns the currently set search depth.
#>
Function Invoke-GotoDevProject {
  [Alias("proj")]
  [Alias("p")]
  [CmdletBinding(DefaultParameterSetName="GotoProject")]
  param(
    [Parameter(Mandatory = $true, Position = 0, ParameterSetName="GotoProject")]
    [string]$Project,

    [Parameter(ParameterSetName = "GetRootLocation")]
    [switch]$GetRootLocation,

    [Parameter(Mandatory = $true, ParameterSetName = "SetRootLocation")]
    [string]$RootLocation,

    [Parameter(ParameterSetName = "GetSearchDepth")]
    [switch]$GetSearchDepth,

    [Parameter(ParameterSetName = "SetSearchDepth")]
    [int]$Depth = 2
  )

  switch ($PSCmdlet.ParameterSetName) 
  {
    "GetRootLocation" {
      if ($null -eq $env:DevProjectRoot) {
        Write-Warning "No root location has been set."
      }
      else {
        Write-Host $env:DevProjectRoot
      }
    }    
    "SetRootLocation" {
      $convertedPath = $RootLocation
      if (Test-Path $convertedPath -ErrorAction Stop) {
        [Environment]::SetEnvironmentVariable("DevProjectRoot", $convertedPath, [System.EnvironmentVariableTarget]::User)
        $env:DevProjectRoot = $convertedPath
      }
    }
    "GetSearchDepth" {
      if ($null -eq $env:DevProjectDepth) {
        Write-Warning "No search depth has been set."
      }
      else {
        Write-host $env:DevProjectDepth
      }
    }
    "SetSearchDepth" {
      [Environment]::SetEnvironmentVariable("DevProjectDepth", $Depth, [System.EnvironmentVariableTarget]::User)
      $env:DevProjectDepth = $Depth
    }
    default {
      $projectRoot = $env:DevProjectRoot
      $projectDepth = if (-not $null -eq $env:DevProjDepth) { $env:DevProjDeptch } else { 2 }
      if (-not (Test-Path $projectRoot -ErrorAction SilentlyContinue)) {
        $projectRoot = Convert-Path .
      }
      [System.IO.DirectoryInfo[]]$folders = Get-ChildItem -Path $projectRoot -Directory -Filter "*$Project*" -Depth $projectDepth | Where-Object { $_.Parent.FullName -notlike "*$Project*" }
      if ($folders.Count -eq 0 ) {
        Write-Warning "No development project with that name found."
      }
      elseif ($folders.Count -gt 1) {
        # TODO: Handle multiple projects with the same name
        $choice = $folders | Select-Object -ExpandProperty FullName | Out-Menu -Header "Multiple project directories were found." -Footer "Please choose the correct project." -AllowCancel
        Push-Location $choice
      }
      else {
        Push-Location $folders[0].FullName
      }
    }
  }
}