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
  It "A 'b' command should call 'docker-compose b'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams
    
    Invoke-DockerCompose -Command b

    $cmd | Should -Be "build"
  }
  It "A 'c' command should call 'docker-compose create'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command c

    $cmd | Should -Be "create"
  }
  It "A 'd' command should call 'docker-compose down'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command d

    $cmd | Should -Be "down"
  }
  It "A 'l' command should call 'docker-compose logs'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command l

    $cmd | Should -Be "logs"
  }
  It "A 's' command should call 'docker-compose start'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command s

    $cmd | Should -Be "start"
  }
  It "A 'u' command should call 'docker-compose up'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command u

    $cmd | Should -Be "up"
  }
  It "A 'ud' command should call 'docker-compose up --detach'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command ud

    $cmd | Should -Be "up --detach"
  }
  It "A 'x' command should call 'docker-compose stop'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command x

    $cmd | Should -Be "stop"
  }
  It "A 'rmi' command should call 'docker-compose images'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command rmi

    $cmd | Should -Be "images"
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
      Mock -Command "docker-compose.exe" -MockWith { return (Get-Content "$here\mocks\dockerComposeHelp.txt") }
      $sut = Get-Completions "Invoke-DockerCompose "
      $sut.CompletionMatches.CompletionText | Should -Contain $_
    }
  }
}