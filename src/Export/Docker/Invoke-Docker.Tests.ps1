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

  It "A 'b' command should call 'docker build'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams
    
    Invoke-Docker -Command b

    $cmd | Should -Be "build"
  }
  It "A 'c' command should call 'docker container'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command c

    $cmd | Should -Be "container"
  }
  It "A 'cs' command should call 'docker container start'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command cs

    $cmd | Should -Be "container start"
  }
  It "A 'cx' command should call 'docker container stop'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command cx

    $cmd | Should -Be "container stop"
  }
  It "A 'i' command should call 'docker images'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command i

    $cmd | Should -Be "images"
  }
  It "A 't' command should call 'docker tag'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command t

    $cmd | Should -Be "tag"
  }
  It "A 'k' command should call 'docker kill'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command k

    $cmd | Should -Be "kill"
  }
  It "A 'l' command should call 'docker logs'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command l

    $cmd | Should -Be "logs"
  }
  It "A 'li' command should call 'docker login'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command li

    $cmd | Should -Be "login"
  }
  It "A 'lo' command should call 'docker logout'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command lo

    $cmd | Should -Be "logout"
  }
  It "A 'r' command should call 'docker run'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command r

    $cmd | Should -Be "run"
  }
  It "A 'rmc' command should call 'docker container rm'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command rmc

    $cmd | Should -Be "container rm"
  }
  It "A 'p' command should call 'docker push'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command p

    $cmd | Should -Be "push"
  }
  It "A 'v' command should call 'docker volume'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command v

    $cmd | Should -Be "volume"
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
      Mock -CommandName "docker.exe" -MockWith { return (Get-Content "$here\mocks\dockerHelp.txt") }
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
      Mock -CommandName "docker.exe" -MockWith { return (Get-Content "$here\mocks\dockerImageHelp.txt") }
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