function Invoke-DotNet {
    [Alias('dn')]
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
        #SDK commands:
        #add               Add a package or reference to a .NET project.
        'a' { dotnet add $Parameters }
        'apack' { dotnet add package $Parameters }
        'aproj' { dotnet add project $Parameters }
        #build             Build a .NET project.
        'b' { dotnet build $Parameters }
        #build-server      Interact with servers started by a build.
        #clean             Clean build outputs of a .NET project.
        'cl' { dotnet clean $Parameters }
        #help              Show command line help.
        'h' { dotnet help }
        #list              List project references of a .NET project.
        'ls' { dotnet list $Parameters }
        'lspack' { dotnet list package }
        'lsref' { dotnet list reference }
        #msbuild           Run Microsoft Build Engine (MSBuild) commands.
        #new               Create a new .NET project or file.
        'n' { dotnet new $Parameters }
        #nuget             Provides additional NuGet commands.
        'nu' { dotnet nuget $Parameters }
        #pack              Create a NuGet package.
        #publish           Publish a .NET project for deployment.
        #remove            Remove a package or reference from a .NET project.
        'rm' { dotnet remove $Parameters }
        'rmpack' { dotnet remove package $Parameters }
        #restore           Restore dependencies specified in a .NET project.
        're' { dotnet restore $Parameters }
        #run               Build and run a .NET project output.
        'r' { dotnet run $Parameters } 
        #sln               Modify Visual Studio solution files.
        's' { dotnet sln $Parameters }
        #store             Store the specified assemblies in the runtime package store.
        #test              Run unit tests using the test runner specified in a .NET project.
        't' { dotnet test $Parameters }
        #tool              Install or manage tools that extend the .NET experience. 
        #vstest            Run Microsoft Test Engine (VSTest) commands.
        # default { dotnet help $Parameters }
    }
}  