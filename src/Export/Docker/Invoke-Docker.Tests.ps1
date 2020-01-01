$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

# Ensure this scope includes any "Private" methods the Invoke-Docker may call
foreach ($script in (Get-ChildItem -Filter *.ps1 -Exclude *.Tests.ps1 -Recurse ($Script:here -replace "\\Export\\", "\Private\"))) {
  . $script
}

Describe "Testing aliases used by Invoke-Docker" {
  $getParams = {
    param([Parameter(ValueFromRemainingArguments=$true)]$c)
    $Script:cmd = ($c -join " ").Trim()
  }

  # Setup theories
  $aliases = @{
    "b" = "build"
    "c" = "container"
    "cs" = "container start"
    "cx" = "container stop"
    "i" = "images"
    "t" = "tag"
    "k" = "kill"
    "l" = "logs"
    "li" = "login"
    "lo" = "logout"
    "r" = "run"
    "rmc" = "container rm"
    "p" = "push"
    "v" = "volume"
  }

  # Test the theories
  $aliases.Keys | ForEach-Object {
    It "A '$_' command should call '$($aliases[$_])'" {
      $Script:cmd = ""
      Mock -CommandName "docker" -MockWith $getParams
      Invoke-Docker -Command $_
      $cmd | Should -Be ($aliases[$_])
    }
  }
}

Describe "Testing command tab completions for Invoke-Docker" {
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
    "app*","builder","buildx*","checkpoint","config","container","context","image","manifest",
    "network","node","plugin","secret","service","stack","swarm","system","trust","volume",
    "attach","build","commit","cp","create","deploy","diff","events","exec","export","history",
    "images","import","info","inspect","kill","load",    "login","logout","logs","pause","port",
    "ps","pull","push","rename","restart","rm","rmi","run","save","search","start","stats",
    "stop","tag","top","unpause","update","version","wait"
    ) | ForEach-Object {
    It "tab completion should contain '$_'" {
      Mock -CommandName "docker" -MockWith { return (Get-Content "$here\mocks\dockerHelp.txt") }
      $sut = Get-Completions "Invoke-Docker "
      $sut.CompletionMatches.CompletionText | Should -Contain $_
    }
  }
}

Describe "Testing subcommand tab completions for Invoke-Docker" {

  function Get-Completions
  {
      param([string]$inputScript, [int]$cursorColumn = $inputScript.Length)

      $results = [System.Management.Automation.CommandCompletion]::CompleteInput(
          <#inputScript#>  $inputScript,
          <#cursorColumn#> $cursorColumn,
          <#options#>      $null)

      return $results
  }

  # "Subcommand" tab completion should contain these commands
  @(
    "build","history","import","inspect","load","ls","prune",
    "pull","push","rm","save","tag"
  ) | ForEach-Object {
    It "'image' subcommand tab completion should contain '$_'" {
      Mock -CommandName "docker" -MockWith { return (Get-Content "$here\mocks\dockerImageHelp.txt") }
      $sut = Get-Completions "Invoke-Docker image "
      $sut.CompletionMatches.CompletionText | Should -Contain "$_"
    }
  }

  It "'rmi' subcommand tab completion should return 'microsoft/powershell:latest'" {
    Mock -CommandName "Invoke-DockerCommand" -ParameterFilter { $Parameters.Contains("ls") } -MockWith { return (Get-Content "$here\mocks\dockerImages.txt") }
    Mock -CommandName "Invoke-DockerCommand" -ParameterFilter { $Parameters.Contains("inspect") } -MockWith { return (Get-Content "$here\mocks\dockerImagesJson.txt") }
    $sut = Get-Completions "Invoke-Docker rmi "
    $sut.CompletionMatches.CompletionText | Should -Contain "microsoft/powershell:latest"
  }
  
  It "'rm' subcommand tab completion should return 'stoic_pare'" {
    Mock -CommandName "Invoke-DockerCommand" -ParameterFilter { $Parameters.Contains("ps") } -MockWith { return (Get-Content "$here\mocks\dockerContainers.txt") }
    Mock -CommandName "Invoke-DockerCommand" -ParameterFilter { $Parameters.Contains("inspect") } -MockWith { return (Get-Content "$here\mocks\dockerContainersJson.txt") }
    $sut = Get-Completions "Invoke-Docker rm "
    $sut.CompletionMatches.CompletionText | Should -Contain "stoic_pare"
  }
}