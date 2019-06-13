function Invoke-DockerBinding {
    [Alias('d')]

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
        # catchall
        default { docker $Cmd $Params }
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
        # catchall
        default { git $Cmd $Params }
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
        [Alias('Normalize','Horizontal')]
        $Normalise
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
    $input | Sort-Object {(--(Get-Variable rank -Scope 1).Value)}
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
        if(Get-Command code -ErrorAction SilentlyContinue) {
            $fileEditor = 'code'
        } elseif(Get-Command code-insiders -ErrorAction SilentlyContinue) {
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
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    param
    (
    [switch]$AsAdministrator,
    [switch]$Force
    )
    $proc = Get-Process -Id $PID
    $cmdArgs = [Environment]::GetCommandLineArgs() | Select-Object -Skip 1
    $params = @{FilePath=$proc.Path}
    if ($AsAdministrator){$params.Verb = 'runas'}
    if ($cmdArgs){$params.ArgumentList = $cmdArgs}
    if ($Force -or $PSCmdlet.ShouldProcess($proc.Name,"Restart the console")) {
        if ($host.Name -eq 'Windows PowerShell ISE Host' -and $psISE.PowerShellTabs.Files.IsSaved -contains $false) {
            if ($Force -or $PSCmdlet.ShouldProcess('Unsaved work detected?','Unsaved work detected. Save changes?','Confirm')) {
                foreach ($IseTab in $psISE.PowerShellTabs) {
                    $IseTab.Files | ForEach-Object {
                        if ($_.IsUntitled -and !$_.IsSaved) {
                            $_.SaveAs($_.FullPath,[System.Text.Encoding]::UTF8)
                        }
                        elseif(!$_.IsSaved) {
                            $_.Save()
                        }
                    }
                }
            }
            else {
                foreach ($IseTab in $psISE.PowerShellTabs) {
                    $unsavedFiles = $IseTab.Files | Where-Object IsSaved -eq $false
                    $unsavedFiles | ForEach-Object {$IseTab.Files.Remove($_,$true)}
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