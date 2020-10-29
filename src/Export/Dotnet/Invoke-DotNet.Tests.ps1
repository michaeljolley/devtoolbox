
$Script:here = Split-Path -Parent $MyInvocation.MyCommand.Path
$Script:sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace "\.Tests\.", "."
. "$here\$sut"

Describe "Testing aliases used by Invoke-DotNet" {
    $getParams = {
        param([Parameter(ValueFromRemainingArguments = $true)]$c)
        $Script:cmd = ($c -join " ").Trim()
    }

    # Setup theories
    $aliases = @{
        #Default to accepting "package/project"
        'a'      = "add"
        'apack'  = "add package"
        'aproj'  = "add project"
        #build             Build a .NET project.
        'b'      = "build"
        #build-server      Interact with servers started by a build.
        #clean             Clean build outputs of a .NET project.
        'cl'     = "clean"
        #help              Show command line help.
        'h'      = "help"
        #list              List project references of a .NET project.
        'ls'     = "list"
        #msbuild           Run Microsoft Build Engine (MSBuild) commands.
        #new               Create a new .NET project or file.
        'n'      = "new"
        #nuget             Provides additional NuGet commands.
        'nu'     = "nuget"
        #pack              Create a NuGet package.
        #publish           Publish a .NET project for deployment.
        #remove            Remove a package or reference from a .NET project.
        'rm'     = "remove"
        'rmpack' = "remove package"
        'rmproj' = "remove project"
        #restore           Restore dependencies specified in a .NET project.
        're'     = "restore"
        #run               Build and run a .NET project output.
        'r'      = "run"
        #sln               Modify Visual Studio solution files.
        's'      = "sln"
        #store             Store the specified assemblies in the runtime package store.
        #test              Run unit tests using the test runner specified in a .NET project.
        't'      = "test"
        #tool              Install or manage tools that extend the .NET experience.
        #vstest            Run Microsoft Test Engine (VSTest) commands.

    }
    # Test theories
    $aliases.Keys | ForEach-Object {
        It "A '$_' command should call '$($aliases[$_])'" {
            $Script:cmd = ""
            Mock -CommandName "dotnet" -MockWith $getParams
            Invoke-DotNet -Command $_
            $cmd | Should -Be ($aliases[$_])
        }
    }
}