function Get-DockerCommand {
  [CmdletBinding()]
  param (
    [Parameter()]
    [string]
    $Command
  )
  $help = $(if ($Command) { docker $Command --help } else { docker --help }) | Select-String -Pattern "^\s{2}\w+"
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
}