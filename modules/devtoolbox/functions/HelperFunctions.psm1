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
Function Restore-WorkspacePackages {
  [Alias('rwp')]
  [CmdletBinding(DefaultParameterSetName = "Default")]
  Param (
    [Parameter(ParameterSetName = "NPM", HelpMessage = "Restore only NPM packages")]
    [switch]$NPM,
    [Parameter(ParameterSetName = "Nuget", HelpMessage = "Restore only Nuget packages")]
    [switch]$Nuget,
    [Parameter(ParameterSetName = "Libman", HelpMessage = "Restore only Library Manager packages")]
    [switch]$Libman
  )

  DynamicParam {
    $paramDictionary = New-Object System.Management.Automation.RuntimeDefinedParameterDictionary
    if ($NPM) {
      $cleanSlateAttribute = New-Object System.Management.Automation.ParameterAttribute
      $cleanSlateAttribute.Position = 1
      $cleanSlateAttribute.Mandatory = $false
      $cleanSlateAttribute.HelpMessage = "Installs NPM packages with a clean slate"
      $attributeCollection = New-Object System.Collections.ObjectModel.Collection[System.Attribute]
      $attributeCollection.Add($cleanSlateAttribute)
      $cleanSlateParam = New-Object System.Management.Automation.RuntimeDefinedParameter('CI', [switch], $attributeCollection)
      $paramDictionary.Add('CI', $cleanSlateParam)
    }
    return $paramDictionary
  }

  Process {

    $restoreNpm = -not ($null -eq (Get-Command npm -ErrorAction SilentlyContinue))
    $restoreDotnet = -not ($null -eq (Get-Command dotnet -ErrorAction SilentlyContinue))
    $restoreLibman = -not ($null -eq (Get-Command libman -ErrorAction SilentlyContinue))

    if ($restoreNpm -and ($PSCmdlet.ParameterSetName -eq "Default" -or $PSCmdlet.ParameterSetName -eq "NPM")) {
      Write-Host "Restoring NPM packages" -NoNewLine
      $children = Get-ChildItem -Filter package.json -Recurse | Where-Object Directory -NotLike "*node_module*"
      Write-Host (": Found {0} NPM projects" -f $children.Count) -ForegroundColor Yellow
      $children | ForEach-Object {
        Write-Host "-  Restoring $($_.Directory)..." -ForegroundColor Yellow
        Push-Location $_.Directory
        if ($PSBoundParameters.ContainsKey("CI")) {
          Write-Host "Cleaning Slate..."
          npm ci
        }
        else {
          npm install
        }
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
  # [Alias("Reload")]
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

Function Out-Menu {
  [Alias("menu")]
  param(
    [Parameter(Mandatory = $true, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true)]
    [object[]]$Object,
    [string]$Header,
    [string]$Footer,
    [switch]$AllowCancel,
    [switch]$AllowMultiple
  )

  if ($input) {
    $Object = @($input)
  }

  Write-Host ""

  do {
    $prompt = New-Object System.Text.StringBuilder
    switch ($true) {
      { [bool]$Header -and $Header -notmatch '^(?:\s+)?$' } { $null = $prompt.Append($Header); break }
      $true { $null = $prompt.Append('Choose an option:') }
      $AllowCancel { $null = $prompt.Append(', or enter "c" to cancel.') }
      $AllowMultiple { $null = $prompt.Append('`nTo select multiple, enter numbers separated by a comma. EX: 1, 2') }
    }

    Write-Host $prompt.ToString()

    $nums = $Object.Count.ToString().Length
    for ($i = 0; $i -lt $Object.Count; $i++) {
      Write-Host "$("{0:D$nums}" -f ($i+1)). $($Object[$i])"
    }

    if ($Footer) {
      if ($Footer.EndsWith(".")) {
        $Footer = $Footer.Replace(".",":")
      }
      Write-Host $Footer " " -NoNewLine
    }

    if ($AllowMultiple) {
      $answers = @(Read-Host).Split(",").Trim()

      if ($AllowCancel -and $answers -match 'c') {
        return
      }

      $ok = $true
      foreach ($ans in $answers) {
        if ($ans -in 1..$Object.Count) {
          $Object[$ans - 1]          
        }
        else {
          Write-Host "Not an option!" -ForegroundColor Red
          Write-Host ""
          $ok = $false
        }
      }
    }
    else {
      $answer = Read-Host

      if ($AllowCancel -and $answer -eq 'c') {
        return
      }

      $ok = $true
      if ($answer -in 1..$Object.Count) {
        $Object[$answer - 1]
      } 
      else {
        Write-Host "Not an option!" -ForegroundColor Red
        Write-Host ""
        $ok = $false
      }
    }
  } while (-not $ok)
}
