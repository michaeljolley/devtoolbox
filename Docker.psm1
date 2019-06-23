Function Get-DockerContainers {
  param([switch]$a)
  $params = @()
  $params += "container","ls"
  if ($a) { $params += "-a" }

  $containers = docker @params

  $titles = [regex]::Split($containers[0], "\s{2,}") | ForEach-Object { return (Get-Culture).TextInfo.ToTitleCase($_.ToLower()) }

  $infos = @()
  $containers | Select-Object -Skip 1 | ForEach-Object {
    $info = New-Object PSCustomObject
    for ($i = 0; $i -lt $titles.Count; $i++) {
      $r = $_
      $columnStartIndex = ($containers | Select-String -Pattern "$($titles[$i])").Matches.Index
      $columnEndIndex = $(if (($i+1) -lt $titles.Count) { ($containers | Select-String -Pattern "$($titles[$i+1])").Matches.Index } else { $r.Length })
      $column = $r.Substring($columnStartIndex, $columnEndIndex - $columnStartIndex).Trim()
      $info | Add-Member -MemberType NoteProperty -Name $titles[$i].Replace(" ", "") -Value $column
    }
    $infos += $info
  }

  return $infos
}
Function Get-DockerImages {
  param(
    [switch]$a
  )
  
  $params = @()
  $params += "image","ls"
  if ($a) {
    $params += "-a"
  }

  $images = docker @params

  $titles = [regex]::Split($images[0], "\s{2,}") | ForEach-Object { return (Get-Culture).TextInfo.ToTitleCase($_.ToLower()) }

  $infos = @()
  $images | Select-Object -Skip 1 | ForEach-Object {
    $columns = [regex]::Split($_, "\s{2,}") | Where-Object { -not [string]::IsNullOrEmpty($_) }
    $info = New-Object PSCustomObject
    for ($i = 0; $i -lt $titles.Count; $i++) {
      
      $info | Add-Member -MemberType NoteProperty -Name $titles[$i].Replace(" ", "") -Value $columns[$i]
    }
    $infos += $info
  }

  return $infos
}
Function Get-DockerCommands {
  param(
    [string]$Command
  )
  $help = $(if ($Command) { docker $Command --help } else { docker --help }) | Select-String -Pattern "^\s{2}\w+"
  $cmds = @()
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmds += $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
  return $cmds
}
Function Invoke-Docker {
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
  $cmds = Get-DockerCommands
  return $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
}

Register-ArgumentCompleter -CommandName Invoke-Docker -ParameterName Parameters -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmd = $fakeBoundParameters["Command"]
  $ast = $commandAst.CommandElements | Where-Object Value -EQ $cmd
  $subcmdidx = $commandAst.CommandElements.IndexOf($ast)
  $subcmd = $commandAst.CommandElements[$subcmdidx + 1].Value

  if ((-not $subcmd -or $subcmd -eq $wordToComplete) -and (Get-DockerCommands) -contains $cmd) {
    $cmds = Get-DockerCommands $cmd
    $results = $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
    if ($results) { return $results }
  }

  if ($cmd -eq "container" -or $cmd -eq "rmc") {
    $containers = Get-DockerContainers -a | Select-Object -ExpandProperty Names
    return $containers
  }

  if ($subcmd -ne "ls" -or $subcmd -ne "build" -or $subcmd -ne "import") {
    $images = Get-DockerImages -a | Select-Object ImageId, @{Name="RepoTag";Expression={$_.Repository+":"+$_.Tag}}
    $options = @()
    $options += $images | Where-Object {$_.RepoTag -ne "<none>:<none>"} | Select-Object -ExpandProperty RepoTag
    $options += $images | Where-Object {$_.RepoTag -eq "<none>:<none>"} | Select-Object -ExpandProperty ImageId
    $options = $options | Where-Object {-not ($commandAst.CommandElements | Select-Object -ExpandProperty Value).Contains($_)}
    return $options
  }
}