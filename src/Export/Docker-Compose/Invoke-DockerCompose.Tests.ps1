$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

$getParams = {
  param([Parameter(ValueFromRemainingArguments=$true)]$c)
  $Script:cmd = ($c -join " ").Trim()
}

Describe "Invoke-Docker" {
  It "A 'b' command should call 'docker-compose b'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams
    
    Invoke-DockerCompose -Command b

    $cmd | Should Be "build"
  }
  It "A 'c' command should call 'docker-compose create'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command c

    $cmd | Should Be "create"
  }
  It "A 'd' command should call 'docker-compose down'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command d

    $cmd | Should Be "down"
  }
  It "A 'l' command should call 'docker-compose logs'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command l

    $cmd | Should Be "logs"
  }
  It "A 's' command should call 'docker-compose start'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command s

    $cmd | Should Be "start"
  }
  It "A 'u' command should call 'docker-compose up'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command u

    $cmd | Should Be "up"
  }
  It "A 'ud' command should call 'docker-compose up --detach'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command ud

    $cmd | Should Be "up --detach"
  }
  It "A 'x' command should call 'docker-compose stop'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command x

    $cmd | Should Be "stop"
  }
  It "A 'rmi' command should call 'docker-compose images'" {
    $Script:cmd = ""
    Mock -CommandName "docker-compose.exe" -MockWith $getParams

    Invoke-DockerCompose -Command rmi

    $cmd | Should Be "images"
  }
}