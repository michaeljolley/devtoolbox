$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

$Script:getParams = {
  param([Parameter(ValueFromRemainingArguments=$true)]$c)
  $Script:cmd = ($c -join " ").Trim()
}

Describe "Invoke-Docker" {
  It "A 'b' command should call 'docker build'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams
    
    Invoke-Docker -Command b

    $cmd | Should Be "build"
  }
  It "A 'c' command should call 'docker container'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command c

    $cmd | Should Be "container"
  }
  It "A 'cs' command should call 'docker container start'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command cs

    $cmd | Should Be "container start"
  }
  It "A 'cx' command should call 'docker container stop'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command cx

    $cmd | Should Be "container stop"
  }
  It "A 'i' command should call 'docker images'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command i

    $cmd | Should Be "images"
  }
  It "A 't' command should call 'docker tag'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command t

    $cmd | Should Be "tag"
  }
  It "A 'k' command should call 'docker kill'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command k

    $cmd | Should Be "kill"
  }
  It "A 'l' command should call 'docker logs'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command l

    $cmd | Should Be "logs"
  }
  It "A 'li' command should call 'docker login'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command li

    $cmd | Should Be "login"
  }
  It "A 'lo' command should call 'docker logout'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command lo

    $cmd | Should Be "logout"
  }
  It "A 'r' command should call 'docker run'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command r

    $cmd | Should Be "run"
  }
  It "A 'rmc' command should call 'docker container rm'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command rmc

    $cmd | Should Be "container rm"
  }
  It "A 'p' command should call 'docker push'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command p

    $cmd | Should Be "push"
  }
  It "A 'v' command should call 'docker volume'" {
    $Script:cmd = ""
    Mock -CommandName "docker.exe" -MockWith $getParams

    Invoke-Docker -Command v

    $cmd | Should Be "volume"
  }
}
