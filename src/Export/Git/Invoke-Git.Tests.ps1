$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

Describe "Testing aliases used by Invoke-Git" {
  $getParams = {
    param([Parameter(ValueFromRemainingArguments=$true)]$c)
    $Script:cmd = ($c -join " ").Trim()
  }

  # Setup theories
  $aliases = @{
    'a' = "add"
    'b' = "branch"
    'c' = "checkout"
    'cl' = "clone"
    'co' = "commit"
    'f' = "fetch"
    'i' = "init"
    'l' = "log"
    'll' = "log --graph --pretty=format:%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset --abbrev-commit"
    'm' = "merge"
    'pl' = "pull"
    'ps' = "push"
    'r' = "rebase"
    'rs' = "reset"
    's' = "status"
    't' = "tag"
  }

  # Test theories
  $aliases.Keys | ForEach-Object {
    It "A '$_' command should call '$($aliases[$_])'" {
      $Script:cmd = ""
      Mock -CommandName "git" -MockWith $getParams
      Invoke-Git -Command $_
      $cmd | Should -Be ($aliases[$_])
    }
  }
}