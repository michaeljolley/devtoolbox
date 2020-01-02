function Invoke-Git {
  [Alias('g')]
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [Alias("cmd")]
    [String]
    $Command,
    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [Alias("params")]
    [String[]]
    $Parameters
  )

  Switch ($Command) {
    # add
    'a' { git add $Parameters }
    # branch
    'b' { git branch $Parameters }
    # checkout
    'c' { git checkout $Parameters }
    # clone repo
    'cl' { git clone $Parameters }
    # commit
    'co' { git commit $Parameters }
    # fetch
    'f' { git fetch $Parameters }
    # init
    'i' { git init $Parameters }
    # log
    'l' { git log $Parameters }
    # pretty log
    'll' { git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit }
    # merge
    'm' { git merge $Parameters }
    # pull
    'pl' { git pull $Parameters }
    # push
    'ps' { git push $Parameters }
    # rebase
    'r' { git rebase $Parameters }
    # reset changes
    'rs' { git reset $Parameters }
    # status
    's' { git status $Parameters }
    # tag
    't' { git tag $Parameters }
    # catchall
    default { git $Command $Parameters }
  }
}