function Invoke-DockerCommand {
  <#
    .SYNOPSIS
    We use this to to call directly to docker to allow us to override
    the output in tests
  #>
  param(
    [Parameter(ValueFromRemainingArguments = $true)]
    [Object[]]
    $Parameters
  )

  (docker @Parameters)
}