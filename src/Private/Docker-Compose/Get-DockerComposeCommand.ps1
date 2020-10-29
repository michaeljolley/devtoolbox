Function Get-DockerComposeCommand {
  $help = docker-compose --help | Select-String -Pattern "^\s{2}\w+" | Select-Object -Skip 2
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
}