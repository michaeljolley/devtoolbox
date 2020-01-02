function Invoke-Docker {
  [Alias("d")]
  Param
  (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command,
    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]$Parameters
  )

  $params = @()
  $params += $Parameters

  switch ($Command) {
    "b" { docker build @params }
    "c" { docker container @params }
    "cs" { docker container start @params }
    "cx" { docker container stop @params }
    "i" { docker images @params }
    "t" { docker tag @params }
    "k" { docker kill @params }
    "l" { docker logs @params }
    "li" { docker login @params }
    "lo" { docker logout @params }
    "r" { docker run @params  }
    # This alias should be deprecated as 'rm' is already an alias for 'container rm'
    "rmc" { docker container rm @params }
    "p" { docker push @params }
    "v" { docker volume @params }
    default { docker $Command @params }
  }
}

Register-ArgumentCompleter -CommandName Invoke-Docker -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  Get-DockerCommand | Where-Object { $_ -like "$wordToComplete*" }
}

Register-ArgumentCompleter -CommandName Invoke-Docker -ParameterName Parameters -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmd = $fakeBoundParameters["Command"]
  $subcmd = $commandAst.CommandElements[2].Value
  
  $retval = Get-DockerCommand $cmd | Where-Object { $_ -like "$wordToComplete*" }

  if ($null -ne $subcmd -or $cmd -eq "rm" -or $cmd -eq "rmi" -or $cmd -eq "rmc") {
    if ($cmd -eq "container" -or $cmd -eq "rm" -or $cmd -eq "rmc") {
      $retval = Get-DockerContainer -All | Select-Object -ExpandProperty Names
    }
    if ($cmd -eq "image" -or $cmd -eq "rmi") {
      $retval = Get-DockerImage -All | Select-Object -ExpandProperty Name
    }
  }

  $retval
}