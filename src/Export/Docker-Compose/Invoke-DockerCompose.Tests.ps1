$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

# Ensure this scope includes any "Private" methods the Invoke-Docker may call
foreach ($script in (Get-ChildItem -Filter *.ps1 -Exclude *.Tests.ps1 -Recurse ($Script:here -replace "\\Export\\", "\Private\"))) {
  . $script
}

Describe "Testing aliases used by Invoke-DockerCompose" {
  $getParams = {
    param([Parameter(ValueFromRemainingArguments=$true)]$c)
    $Script:cmd = ($c -join " ").Trim()
  }

  # Setup theories
  $aliases = @{
    "b" = "build"
    "c" = "create"
    "d" = "down"
    "l" = "logs"
    "s" = "start"
    "u" = "up"
    "ud" = "up --detach"
    "x" = "stop"
    "rmi" = "images"
  }

  # Test theories
  $aliases.Keys | ForEach-Object {
    It "A '$_' command should call '$($aliases[$_])'" {
      $Script:cmd = ""
      Mock -CommandName "docker-compose" -MockWith $getParams
      Invoke-DockerCompose -Command $_
      $cmd | Should -Be ($aliases[$_])
    }
  }
}

Describe "Testing command tab completions for Invoke-DockerCompose" {
  function Get-Completions
  {
      param([string]$inputScript, [int]$cursorColumn = $inputScript.Length)

      $results = [System.Management.Automation.CommandCompletion]::CompleteInput(
          <#inputScript#>  $inputScript,
          <#cursorColumn#> $cursorColumn,
          <#options#>      $null)

      return $results
  }

  # "Command" tab completion should contain these commands
  @(
    "build","bundle","config","create","down","events","exec",
    "help","images","kill","logs","pause","port","ps","pull",
    "push","restart","rm","run","scale","start","stop","top",
    "unpause","up","version"
  ) | ForEach-Object {
    It "tab completion should contain '$_'" {
      Mock -Command "docker-compose" -MockWith { return (Get-Content "$here\mocks\dockerComposeHelp.txt") }
      $sut = Get-Completions "Invoke-DockerCompose "
      $sut.CompletionMatches.CompletionText | Should -Contain $_
    }
  }
}