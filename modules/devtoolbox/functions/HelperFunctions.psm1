<#
    .SYNOPSIS
    Restore NPM, Nuget, and/or Libman packages within this directory or sub-directories

    .PARAMETER NPM
    Restore NPM packages

    .PARAMETER Nuget
    Restore Nuget packages

    .PARAMETER Libman
    Restore Libman packages

    .LINK
    https://github.com/michaeljolley/ps-alias
#>
Function Restore-WorkspacePackages {
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

Function Get-Syntax {
  [CmdletBinding()]
  [Alias('Syntax')]
  param (
    [Parameter(Mandatory)]
    $Command,

    [switch]
    [Alias('Normalize', 'Horizontal')]
    $Normalise
  )

  $check = Get-Command -Name $Command

  $params = @{
    Name   = if ($check.CommandType -eq 'Alias') {
      Get-Command -Name $check.Definition
    }
    else {
      $Command
    }
    Syntax = $true
  }
  if ($Normalise) {
    Get-Command @params
  }
  else {
    (Get-Command @params) -replace '(\s(?=\[)|\s(?=-))', "`r`n "
  }
}

Function Invoke-ReverseSort {
  [Alias("Sort-Reverse")]
  # Sort is not an approved verb... Not sure of better one that is an approved verb. Will just leave this comment with link for future reference: https://github.com/PowerShell/PowerShell/issues/3370
  $rank = [int]::MaxValue
  $input | Sort-Object { (--(Get-Variable rank -Scope 1).Value) }
}

<#
  .SYNOPSIS
  Opens the Windows hosts file in an editor.
#>
Function Edit-HostsFile {
  [Alias('hosts')]
  [CmdletBinding()]
  Param()
  # TO CONSIDER: Should we take a
  # Make sure we're on Windows...
  if ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) {
    # Default editor to notepad.exe
    $fileEditor = 'notepad'
    # Find code if it exists. Giving preference to Stable code over insiders.
    if (Get-Command code -ErrorAction SilentlyContinue) {
      $fileEditor = 'code'
    }
    elseif (Get-Command code-insiders -ErrorAction SilentlyContinue) {
      $fileEditor = 'code-insiders'
    }
    # Use Start-Process to ensure that we're elevated. If already elevated, will not reprompt.
    Start-Process -FilePath $fileEditor -ArgumentList "C:\Windows\System32\drivers\etc\hosts" -Verb RunAs
  }
}

<#
  .SYNOPSIS
  Check to see if the current user is an administrator
#>
Function Test-PSHostHasAdministrator {
  [Alias("IsAdmin")]
  param()
  $p = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
  if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    return $true
  }
  else {
    return $false
  }
  return $false
}

Function Restart-PSHost {
  [Alias("Reload")]
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param
  (
    [switch]$AsAdministrator,
    [switch]$Force
  )
  $proc = Get-Process -Id $PID
  $cmdArgs = [Environment]::GetCommandLineArgs() | Select-Object -Skip 1
  $params = @{FilePath = $proc.Path }
  if ($AsAdministrator) { $params.Verb = 'runas' }
  if ($cmdArgs) { $params.ArgumentList = $cmdArgs }
  if ($Force -or $PSCmdlet.ShouldProcess($proc.Name, "Restart the console")) {
    if ($host.Name -eq 'Windows PowerShell ISE Host' -and $psISE.PowerShellTabs.Files.IsSaved -contains $false) {
      if ($Force -or $PSCmdlet.ShouldProcess('Unsaved work detected?', 'Unsaved work detected. Save changes?', 'Confirm')) {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $IseTab.Files | ForEach-Object {
            if ($_.IsUntitled -and !$_.IsSaved) {
              $_.SaveAs($_.FullPath, [System.Text.Encoding]::UTF8)
            }
            elseif (!$_.IsSaved) {
              $_.Save()
            }
          }
        }
      }
      else {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $unsavedFiles = $IseTab.Files | Where-Object IsSaved -eq $false
          $unsavedFiles | ForEach-Object { $IseTab.Files.Remove($_, $true) }
        }
      }
    }
    Start-Process @params
    $proc.CloseMainWindow()
  }
}

# The following commented out section doesn't work in a module for me

# <#
#   .SYNOPSIS
#   Restarts PowerShell in-place. Useful in the event you have added something to the path or user profile script and need a powershell restart in order for it to be recognized.

#   .DESCRIPTION
#   Powershell reload is based on code from this article by Øyvind Kallstad. -> https://communary.net/2015/05/28/how-to-reload-the-powershell-console-session/
# #>
# Function Invoke-PowerShell {
#   powershell -nologo
#   Invoke-PowerShell
# }

# Function Restart-PowerShell {
#   [Alias("reload")]
#   param()
#   if ($Host.Name -eq "ConsoleHost") {
#     exit
#   }
#   Write-Warning "Only usable while in the PowerShell console host"
# }

# # This code breaks the powershell reload infinite loop, so it's not calling itself forever.
# $parentProcessId = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID").ParentProcessId
# $parentProcessName = (Get-WmiObject Win32_Process -Filter "ProcessId=$parentProcessId").ProcessName

# if ($host.Name -eq 'ConsoleHost') {
#   if (-not($parentProcessName -eq 'powershell.exe')) {
#     Invoke-PowerShell
#   }
# }
# # END POWERSHELL RELOAD
