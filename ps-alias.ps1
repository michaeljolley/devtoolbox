function DockerBinding {

    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $Cmd,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
        [String[]]
        $Params
    )

    Switch ($Cmd)
    {
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
    }
}

function GitBinding {

    Param(
        [Parameter(Mandatory = $true, Position = 0)]
        [String]
        $Cmd,

        [Parameter(Mandatory = $false, ValueFromRemainingArguments = $true)]
        [String[]]
        $Params
    )

    Switch ($Cmd)
    {
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
function Syntax {
    [CmdletBinding()]
    param (
        $Command,

        [switch]
        $PrettySyntax
    )

    $check = Get-Command -Name $Command

    $params = @{
        Name =  if ($check.CommandType -eq 'Alias') {
                    Get-Command -Name $check.Definition
                }
                else {
                    $Command
                }
        Syntax = $true
    }
    if ($PrettySyntax) {
        (Get-Command @params) -replace '(\s(?=\[)|\s(?=-))', "`r`n "
    }
    else {
        Get-Command @params
    }
}

function Sort-Reverse {
    $rank = [int]::MaxValue
    $input | Sort-Object {(--(Get-Variable rank -Scope 1).Value)}
}

# Opens the Windows hosts file in VS code.
function hosts {
    code "C:\Windows\System32\drivers\etc\hosts"
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
Set-Alias d DockerBinding
Set-Alias g GitBinding
