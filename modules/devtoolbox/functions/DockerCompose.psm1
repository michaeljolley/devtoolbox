Function Get-DockerComposeCommands {
  param(
    [string]$Command
  )
  $help = $(if ($Command) { docker-compose $Command --help } else { docker-compose --help }) | Select-String -Pattern "^\s{2}\w+" | Where-Object { $_ -notlike "*docker-compose*" }
  $cmds = @()
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmds += $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
  return $cmds
}
Function Get-DockerComposeServices {
  param
  (
    [Parameter(Mandatory = $true)]
    [string]$Path
  )
  if (-not (Test-Path $Path)) {
    throw
  }
  $file = Get-Content (Convert-Path $Path)
  $categories = $file | Select-String -Pattern "^\w+:"
  $service = $categories | Where-Object {$_.Line -like "services:*"}
  $serviceIdx = $categories.IndexOf($service)
  $startLine = ($categories[$serviceIdx] | Select-Object -ExpandProperty LineNumber)
  $endLine = $(if ($serviceIdx -lt $categories.Length - 1) {$categories[$serviceIdx+1] | Select-Object -ExpandProperty LineNumber} else {$file.Count})
  return $file | Select-Object -Skip $startLine -First ($endLine - $startLine) | Select-String -Pattern "^\s{2}\w+:" | Select-Object @{Name="Service";Expression={$_.Line.Trim().Replace(":","")}} | Sort-Object -Property Service
}
Function Invoke-DockerCompose {
  [Alias("dc")]
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
    "b" { docker-compose build @params }
    "c" { docker-compose create @params }
    "d" { docker-compose down @params }
    "l" { docker-compose logs @params }
    "s" { docker-compose start @params }
    "u" { docker-compose up @params }
    "ud" { docker-compose up --detach @params }
    "x" { docker-compose stop @params }
    "rmi" { docker-compose images }
    default { docker-compose $Command @params }
  }
}

Register-ArgumentCompleter -CommandName Invoke-DockerCompose -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmds = Get-DockerComposeCommands
  return $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
}

Register-ArgumentCompleter -CommandName Invoke-DockerCompose -ParameterName Parameters -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $fIdx = $commandAst.CommandElements | Where-Object {$_.Value -eq "-f" -or $_.Value -eq "--file"}
  $file = $commandAst[$fIdx+1].Value
  $__dirname = Convert-Path .\
  if ($null -eq $file) {
    $file = [System.IO.Path]::Combine($__dirname, "docker-compose.yml")
    if (-not (Test-Path $file)) {
      $file = [System.IO.Path]::Combine($__dirname, "docker-compose.yaml")
    }
  }
  $services = Get-DockerComposeServices -Path $file | Select-Object -ExpandProperty Service
  if ($wordToComplete) {
    return $services | Where-Object { $_ -like "$wordToComplete*" }
  }
  else {
    return $services | Where-Object {-not ($commandAst.CommandElements | Select-Object -ExpandProperty Value).Contains($_)}
  }
}

Export-ModuleMember -Alias * -Function *
