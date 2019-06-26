<#
  .SYNOPSIS
  Get the current set depth to recurse when looking for a project directory
#>
Function Get-GotoDevProjectDepth {
  [Alias("get-proj-depth")]
  param()
                    
  if ($null -eq $env:DevProjectDepth) {
    Write-Warning "No development project root has been set."
  }
  else {
    Write-Host $env:DevProjectDepth
  }
}
<#
  .SYNOPSIS
  Sets the depth of directories to recurse when looking for the project directory
#>
Function Set-GotoDevProjectDepth {
  [Alias("set-proj-depth")]
  param(
    [Parameter(Position = 0)]
    [string]$Depth = 2
  )
  [Environment]::SetEnvironmentVariable("DevProjectDepth", $Depth, [System.EnvironmentVariableTarget]::User)
  $env:DevProjectDepth = $Depth
}
<#
  .SYNOPSIS
  Get the current set root directory to search for a project directory
#>
Function Get-GotoDevProjectRoot {  
  [Alias("get-proj-root")]
  [Alias("get-proj")]
  param()
                    
  if ($null -eq $env:DevProjectRoot) {
    Write-Warning "No development project root has been set."
  }
  else {
    Write-Host $env:DevProjectRoot
  }
}
<#
  .SYNOPSIS
  Sets the root directory to search for a project directory
#>
Function Set-GotoDevProjectRoot {
  [Alias("set-proj-root")]
  [Alias("set-proj")]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$RootPath
  )
  $convertedPath = Convert-Path $RootPath  
  if (Test-Path $convertedPath -ErrorAction Stop) {
    [Environment]::SetEnvironmentVariable("DevProjectRoot", $convertedPath, [System.EnvironmentVariableTarget]::User)
    $env:DevProjectRoot = Convert-Path $convertedPath
  }
}
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
#>
Function Invoke-GotoDevProject {
  [Alias("proj")]
  [Alias("p")]
  param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Project
  )
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