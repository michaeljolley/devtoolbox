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
    "rmc" { docker container rm @params }
    "p" { docker push @params }
    "v" { docker volume @params }
    default { docker $Command @params }
  }
}

Register-ArgumentCompleter -CommandName Invoke-Docker -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmds = Get-DockerCommand
  return $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
}

Register-ArgumentCompleter -CommandName Invoke-Docker -ParameterName Parameters -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmd = $fakeBoundParameters["Command"]
  $ast = $commandAst.CommandElements | Where-Object Value -EQ $cmd
  $subcmdidx = $commandAst.CommandElements.IndexOf($ast)
  $subcmd = $commandAst.CommandElements[$subcmdidx + 1].Value

  if ((-not $subcmd -or $subcmd -eq $wordToComplete) -and (Get-DockerCommand) -contains $cmd) {
    $cmds = Get-DockerCommand $cmd
    $results = $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
    if ($results) { return $results }
  }

  if ($cmd -eq "container" -or $cmd -eq "rmc") {
    $containers = Get-DockerContainer -a | Select-Object -ExpandProperty Names
    return $containers
  }

  if ($subcmd -ne "ls" -or $subcmd -ne "build" -or $subcmd -ne "import") {
    $images = Get-DockerImage -a | Select-Object ImageId, @{Name="RepoTag";Expression={$_.Repository+":"+$_.Tag}}
    $options = @()
    $options += $images | Where-Object {$_.RepoTag -ne "<none>:<none>"} | Select-Object -ExpandProperty RepoTag
    $options += $images | Where-Object {$_.RepoTag -eq "<none>:<none>"} | Select-Object -ExpandProperty ImageId
    $options = $options | Where-Object {-not ($commandAst.CommandElements | Select-Object -ExpandProperty Value).Contains($_)}
    return $options
  }
}