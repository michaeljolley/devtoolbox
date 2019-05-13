Function Docker-Binding {

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
        # list containers
        'c' { docker container ps $Params }
        # stop container
        'cx' { docker container stop $Params }
        # start container
        'cs' { docker container start $Params }
        # remove container
        'cr' { docker container rm $Params }

        
        # list images
        'i' { docker image ls $Params }
        # tag image
        'it' { docker image tag $Params }
        # remove image
        'ir' { docker image rm $Params }

        # build
        'b' { docker build $Params }
        # push
        'p' { docker push $Params }

    }
}

Function Git-Binding {

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
        # status
        's' { git status $Params }
        # tag
        't' { git tag $Params }
        # commit
        'c' { git commit $Params }
        # clone repo
        'cl' { git clone $Params }
        # reset changes
        'r' { git reset $Params }
        # merge
        'm' { git merge $Params }
        # push
        'ps' { git push $Params }
        # pull
        'pl' { git pull $Params }

    }
}

New-Alias d Docker-Binding
New-Alias g GitHub-Binding

