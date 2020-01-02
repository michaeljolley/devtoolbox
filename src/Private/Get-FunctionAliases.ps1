function Get-FunctionAliases ($functions) {
  $aliases = @()
  foreach ($function in $functions) {
    $definition = (Get-Command $function).Definition.Split("`n")
    $paramStartLine = ($definition | Select-String -Pattern "^\s*[Pp]aram").LineNumber
    $aliases += ($definition | Select-String -Pattern "(?<!#\s*)\[Alias\([\""|'](\w+)[\""|']\)\]" | Where-Object LineNumber -LT $paramStartLine).Matches | ForEach-Object {if ($_.Groups.Count -gt 0) { $_.Groups[1].Value }}
  }
  return $aliases
}