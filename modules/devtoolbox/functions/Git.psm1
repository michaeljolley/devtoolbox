Function Invoke-Git {
  [Alias('g')]
  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [String]
    $Cmd,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [String[]]
    $Params
  )

  Switch ($Cmd) {
    # add
    'a' { git add $Params }
    # branch
    'b' { git branch $Params }
    # checkout
    'c' { git checkout $Params }
    # clone repo
    'cl' { git clone $Params }
    # commit
    'co' { git commit $Params }
    # fetch
    'f' { git fetch $Params }
    # init
    'i' { git init $Params }
    # log
    'l' { git log $Params }
    # pretty log
    'll' { git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit }
    # merge
    'm' { git merge $Params }
    # pull
    'pl' { git pull $Params }
    # push
    'ps' { git push $Params }
    # rebase
    'r' { git rebase $Params }
    # reset changes
    'rs' { git reset $Params }
    # status
    's' { git status $Params }
    # tag
    't' { git tag $Params }
    # catchall
    default { git $Cmd $Params }
  }
}