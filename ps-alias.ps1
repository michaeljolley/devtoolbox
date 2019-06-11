function Get-DockerImages {
  param([switch]$a)
  if ($a) {
    $images = (docker image ls -a).Split("`n")
  }
  else {
    $images = (docker image ls).Split("`n")
  }
  $titles = [regex]::Split($images[0], "\s{2,}") | Where-Object { -not [string]::IsNullOrEmpty($_) }
  $rows = $images | Select-Object -Skip 1
  $infos = @()
  $rows | ForEach-Object {
    $columns = [regex]::Split($_, "\s{2,}") | Where-Object { -not [string]::IsNullOrEmpty($_) }
    $obj = New-Object PSCustomObject
    for ($i = 0; $i -lt $titles.Count; $i++) {
      $obj | Add-Member -MemberType NoteProperty -Name $titles[$i] -Value $columns[$i]
    }
    $infos += $obj
  }
  return $infos
}

function Get-DockerCommands {
  param(
    [string]$Command
  )
  $help = $(if ($Command) { docker $Command --help } else { docker --help }) | Select-String -Pattern "^\s{2}\w+"
  $cmds = @()
  for ($i = 0; $i -lt $help.Count; $i++) {
    $cmdline = $help[$i].Line.Trim()
    $cmds += $cmdline.Substring(0, $cmdline.IndexOf(" "))
  }
  return $cmds
}

function Get-DockerContainers {
  param([switch]$a)
  $params = @()
  $params += "container", "ls"
  if ($a) { $params += "-a" }

  $containers = docker @params

  $titles = [regex]::Split($containers[0], "\s{2,}") | ForEach-Object { return (Get-Culture).TextInfo.ToTitleCase($_.ToLower()) }

  $infos = @()
  $containers | Select-Object -Skip 1 | ForEach-Object {
    $info = New-Object PSCustomObject
    for ($i = 0; $i -lt $titles.Count; $i++) {
      $r = $_
      $columnStartIndex = ($containers | Select-String -Pattern "$($titles[$i])").Matches.Index
      $columnEndIndex = $(if (($i + 1) -lt $titles.Count) { ($containers | Select-String -Pattern "$($titles[$i+1])").Matches.Index } else { $r.Length })
      $column = $r.Substring($columnStartIndex, $columnEndIndex - $columnStartIndex).Trim()
      $info | Add-Member -MemberType NoteProperty -Name $titles[$i].Replace(" ", "") -Value $column
    }
    $infos += $info
  }

  return $infos
}

function Invoke-DockerBinding {
  [Alias('d')]

  Param(
    [Parameter(Mandatory = $true, Position = 0)]
    [String]
    $Command,

    [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
    [String[]]
    $Params
  )

  Switch ($Command) {
    # build
    'b' { docker build $Params }
    # list containers
    'c' { docker container ps $Params }
    # remove container
    'cr' { docker container rm $Params }
    # start container
    'cs' { docker container start $Params }
    # stop container
    'cx' { docker container stop $Params }
    # list images
    'i' { docker image ls $Params }
    # remove image
    'ir' { docker image rm $Params }
    # tag image
    't' { docker image tag $Params }
    # kill containers
    'k' { docker kill $Params }
    # fetch logs
    'l' { docker logs $Params }
    # login
    'li' { docker login $Params }
    # logout
    'lo' { docker logout $Params }
    # run
    'r' { docker run $Params }
    # push
    'p' { docker push $Params }
    # catchall
    default { docker $Command $Params }
  }
}

Register-ArgumentCompleter -CommandName Invoke-DockerBinding -ParameterName Command -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmds = Get-DockerCommands
  if ($wordToComplete) {
    $cmds | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object { $_ }
  }
  else {
    $cmds | ForEach-Object { $_ }
  }
}

Register-ArgumentCompleter -CommandName Invoke-DockerBinding -ParameterName Params -ScriptBlock {
  param($commandName, $parameterName, $wordToComplete, $commandAst, $fakeBoundParameters)
  $cmd = $fakeBoundParameters["Command"]
  $ast = $commandAst.CommandElements | Where-Object Value -EQ $cmd
  $subcmdidx = $commandAst.CommandElements.IndexOf($ast)
  $subcmd = $commandAst.CommandElements[$subcmdidx + 1].Value

  if ((-not $subcmd -or $subcmd -eq $wordToComplete) -and (Get-DockerCommands) -contains $cmd) {
    $cmds = Get-DockerCommands $cmd
    $results = $(if ($wordToComplete) { $cmds | Where-Object { $_ -like "$wordToComplete*" } } else { $cmds })
    if ($results) { return $results }
  }

  if ($cmd -eq "container" -or $cmd -eq "cr") {
    $containers = Get-DockerContainers -a | Select-Object -ExpandProperty Names
    return $containers
  }

  if ($subcmd -ne "ls" -or $subcmd -ne "build" -or $subcmd -ne "import") {
    $images = Get-DockerImages -a | Select-Object @{Name = "RepoTag"; Expression = { $_.Repository + ":" + $_.Tag } }
    $options = @()
    $options += $images | Select-Object -ExpandProperty RepoTag
    return $options
  }
}

function Invoke-GitBinding {
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
  }
}

# A wrapper for Get-Command with the -Syntax parameter but can print the syntax down the screen.
function Get-Syntax {
  [CmdletBinding()]
  [Alias('Syntax')]
  param (
    [Parameter(Mandatory)]
    $Command,

    [switch]
    [Alias('Normalize', 'Horizontal')]
    $Normalise
  )

  $check = Get-Command -Name $Command

  $params = @{
    Name   = if ($check.CommandType -eq 'Alias') {
      Get-Command -Name $check.Definition
    }
    else {
      $Command
    }
    Syntax = $true
  }
  if ($Normalise) {
    Get-Command @params
  }
  else {
    (Get-Command @params) -replace '(\s(?=\[)|\s(?=-))', "`r`n "
  }
}

function Sort-Reverse {
  # Sort is not an approved verb... Not sure of better one that is an approved verb. Will just leave this comment with link for future reference: https://github.com/PowerShell/PowerShell/issues/3370
  $rank = [int]::MaxValue
  $input | Sort-Object { (--(Get-Variable rank -Scope 1).Value) }
}

# Opens the Windows hosts file in an editor.
function Edit-HostsFile {
  [Alias('hosts')]
  [CmdletBinding()]
  Param()
  # TO CONSIDER: Should we take a 
  # Make sure we're on Windows...
  if ($PSVersionTable.PSVersion.Major -lt 6 -or $IsWindows) {
    # Default editor to notepad.exe
    $fileEditor = 'notepad'
    # Find code if it exists. Giving preference to Stable code over insiders.
    if (Get-Command code -ErrorAction SilentlyContinue) {
      $fileEditor = 'code'
    }
    elseif (Get-Command code-insiders -ErrorAction SilentlyContinue) {
      $fileEditor = 'code-insiders'
    }
    # Use Start-Process to ensure that we're elevated. If already elevated, will not reprompt.
    Start-Process -FilePath $fileEditor -ArgumentList "C:\Windows\System32\drivers\etc\hosts" -Verb RunAs
  }
}

# BEGIN POWERSHELL RELOAD
# Powershell reload is based on code from this article by Øyvind Kallstad. -> https://communary.net/2015/05/28/how-to-reload-the-powershell-console-session/
# Restarts PowerShell in-place. Useful in the event you have added something to the path or user profile script and need a powershell restart in order for it to be recognized.
function Invoke-PowerShell {
  powershell -nologo
  Invoke-PowerShell
}

function Restart-PowerShell {
  if ($host.Name -eq 'ConsoleHost') {
    exit
  }
  Write-Warning 'Only usable while in the PowerShell console host'
}

# Test if the PSHost session has an administrative token (i.e. elevated host)
function Test-PSHostHasAdministrator {
  $p = New-Object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
  if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)) {
    return $true
  }
  else {
    return $false
  }
  return $false
}

# Restart the PSHost using the same arguments as the current PSHost and allow the user to request an administrative token as well
function Restart-PSHost {
  [CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
  param
  (
    [switch]$AsAdministrator,
    [switch]$Force
  )
  $proc = Get-Process -Id $PID
  $cmdArgs = [Environment]::GetCommandLineArgs() | Select-Object -Skip 1
  $params = @{FilePath = $proc.Path }
  if ($AsAdministrator) { $params.Verb = 'runas' }
  if ($cmdArgs) { $params.ArgumentList = $cmdArgs }
  if ($Force -or $PSCmdlet.ShouldProcess($proc.Name, "Restart the console")) {
    if ($host.Name -eq 'Windows PowerShell ISE Host' -and $psISE.PowerShellTabs.Files.IsSaved -contains $false) {
      if ($Force -or $PSCmdlet.ShouldProcess('Unsaved work detected?', 'Unsaved work detected. Save changes?', 'Confirm')) {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $IseTab.Files | ForEach-Object {
            if ($_.IsUntitled -and !$_.IsSaved) {
              $_.SaveAs($_.FullPath, [System.Text.Encoding]::UTF8)
            }
            elseif (!$_.IsSaved) {
              $_.Save()
            }
          }
        }
      }
      else {
        foreach ($IseTab in $psISE.PowerShellTabs) {
          $unsavedFiles = $IseTab.Files | Where-Object IsSaved -eq $false
          $unsavedFiles | ForEach-Object { $IseTab.Files.Remove($_, $true) }
        }
      }
    }
    Start-Process @params
    $proc.CloseMainWindow()
  }
}

# This code breaks the powershell reload infinite loop, so it's not calling itself forever.
$parentProcessId = (Get-WmiObject Win32_Process -Filter "ProcessId=$PID").ParentProcessId
$parentProcessName = (Get-WmiObject Win32_Process -Filter "ProcessId=$parentProcessId").ProcessName

if ($host.Name -eq 'ConsoleHost') {
  if (-not($parentProcessName -eq 'powershell.exe')) {
    Invoke-PowerShell
  }
}
# END POWERSHELL RELOAD

Set-Alias -Name 'reload' -Value 'Restart-PowerShell'