Function Get-DockerComposeCommand {
  param(
    [string]$Command
  )
  $help = $(if ($Command) { docker-compose $Command --help } else { docker-compose --help }) | Select-String -Pattern "^\s{2}\w+" | Where-Object { $_ -notlike "*docker-compose*" }
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
}