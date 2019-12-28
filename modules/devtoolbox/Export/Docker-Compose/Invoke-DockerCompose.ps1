function Invoke-DockerCompose {
  [Alias("dc")]
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$Command,
    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [string[]]$Parameters
  )

  $params = @($Parameters)

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
  $cmds = Get-DockerComposeCommand
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
  $services = Get-DockerComposeService -Path $file | Select-Object -ExpandProperty Service
  if ($wordToComplete) {
    return $services | Where-Object { $_ -like "$wordToComplete*" }
  }
  else {
    return $services | Where-Object {-not ($commandAst.CommandElements | Select-Object -ExpandProperty Value).Contains($_)}
  }
}