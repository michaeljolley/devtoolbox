Function global:DockerBinding {

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

        # kill containers
        'k' { docker kill $Params }
        # fetch logs
        'l' { docker logs $Params }

        # run
        'r' { docker run $Params }
        
        # build
        'b' { docker build $Params }
        # push
        'p' { docker push $Params }


        # login
        'li' { docker login $Params }
        # logout
        'lo' { docker logout $Params }
    }
}

Function global:GitBinding {

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
        # checkout
        'c' { git checkout $Params }
        # commit
        'co' { git commit $Params }
        # clone repo
        'cl' { git clone $Params }
        # reset changes
        'rs' { git reset $Params }
        # merge
        'm' { git merge $Params }
        # push
        'ps' { git push $Params }
        # pull
        'pl' { git pull $Params }
        # init 
        'i' { git init $Params }
        # branch
        'b' { git branch $Params }
        # rebase 
        'r' { git rebase $Params }
        # fetch
        'f' { git fetch $Params }
    }
}

New-Alias d global:DockerBinding
New-Alias g global:GitBinding

