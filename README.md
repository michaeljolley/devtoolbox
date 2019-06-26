<p align="center">
    <img src="https://user-images.githubusercontent.com/1228996/60140866-b9c3d700-9778-11e9-819b-9e45076a33da.png"/>
</p>

| Release | vNext | Contributors | Downloads
| -- | -- | -- | --
| [![Build Status](https://dev.azure.com/michaeljolley/devtoolbox/_apis/build/status/MichaelJolley.devtools?branchName=master)](https://dev.azure.com/michaeljolley/devtoolbox/_build/latest?definitionId=4&branchName=master) | [![Build Status](https://dev.azure.com/michaeljolley/devtoolbox/_apis/build/status/MichaelJolley.devtools?branchName=vNext)](https://dev.azure.com/michaeljolley/devtoolbox/_build/latest?definitionId=4&branchName=vNext) | [![All Contributors](https://img.shields.io/badge/all_contributors-7-orange.svg?style=flat-square)](#contributing) | [![Downloads](https://img.shields.io/powershellgallery/dt/devtoolbox.svg)](https://www.powershellgallery.com/packages/devtoolbox)

For more information as to how this repo came about, check out this [blog post](https://michaeljolley.com/posts/setup-command-aliases-in-powershell-to-make-life-easier/)

## Parameters

All aliases accept parameters of the commands they call.

For example, the below are identical:

```CMD
g cl https://github.com/MichaelJolley/devtoolbox.git

git clone https://github.com/MichaelJolley/devtoolbox.git
```

## Commands

### Docker

All aliases for Docker begin with `d`.

| Command   | Executes                      |
| ---       | ---                           |
| d b       | docker build                  |
| d c       | docker container ps           |
| d cr      | docker container rm           |
| d cs      | docker container start        |
| d cx      | docker container stop         |
| d i       | docker image ls               |
| d ir      | docker image rm               |
| d k       | docker kill                   |
| d l       | docker logs                   |
| d li      | docker login                  |
| d lo      | docker logout                 |
| d r       | docker run                    |
| d t       | docker image tag              |
| d p       | docker push                   |
| d ...     | docker ...(any parameters)    |

### Docker-Compose

All aliases for Docker Compose begin with `dc`.

| Command   | Executes                                              |
| ---       | ---                                                   |
| dc b      | docker-compose build                                  |
| dc bu     | docker-compose build (params); docker-compose up      |
| dc d      | docker-compose down                                   |
| dc i      | docker-compose images                                 |
| dc u      | docker-compose up                                     |
| dc ...    | docker-compose ... (any parameters)                   |

### Git

All aliases for Git begin with `g`.

| Command   | Executes                      |
| ---       | ---                           |
| g a       | git add                       |
| g b       | git branch                    |
| g c       | git checkout                  |
| g cl      | git clone                     |
| g co      | git commit                    |
| g f       | git fetch                     |
| g i       | git init                      |
| g l       | git log                       |
| g ll      | git log --graph (pretty)      |
| g m       | git merge                     |
| g pl      | git pull                      |
| g ps      | git push                      |
| g r       | git rebase                    |
| g rs      | git reset                     |
| g s       | git status                    |
| g t       | git tag                       |
| g ...     | git ... (any parameters)      |

### Miscellaneous

| Command                           | Executes
| ---                               | ---
| gh                                | Launches browser to GitHub repo if the directory is tracked by Git and its origin url is at GitHub
| hosts                             | If in Windows, opens the hosts file in an elevated editor. Choosing, in order, between VS Code, VS Code (insiders), Notepad.
| reload                            | Restarts PowerShell in-place. Useful in the event you have added something to the path or user profile script and need a powershell restart in order for it to be recognized.
| Restore-WorkspacePackages (rwp)   | Restores NPM, Nuget, and Libman packages starting at the root folder of a workspace.
| Syntax                            | Prints PowerShell Command Syntax vertically, replicating docs.microsoft.com layout
| Sort-Reverse                      | Reverses the order of an array. Accepts pipeline support e.g. `1,2,3,4,5 | Sort-Reverse`

## Contributing

Want to contribute? Check out our [Code of Conduct](CODE_OF_CONDUCT.md) and [Contributing](CONTRIBUTING.md) docs. This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.  Contributions of any kind welcome!

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table><tr><td align="center"><a href="https://michaeljolley.com/"><img src="https://avatars2.githubusercontent.com/u/1228996?v=4" width="100px;" alt="Michael Jolley"/><br /><sub><b>Michael Jolley</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=MichaelJolley" title="Code">💻</a> <a href="#ideas-MichaelJolley" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=MichaelJolley" title="Documentation">📖</a></td><td align="center"><a href="http://ryanhayes.net"><img src="https://avatars3.githubusercontent.com/u/438357?v=4" width="100px;" alt="Ryan Hayes"/><br /><sub><b>Ryan Hayes</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=RyannosaurusRex" title="Code">💻</a> <a href="#ideas-RyannosaurusRex" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=RyannosaurusRex" title="Documentation">📖</a></td><td align="center"><a href="https://github.com/parithon"><img src="https://avatars3.githubusercontent.com/u/8602418?v=4" width="100px;" alt="Anthony Conrad"/><br /><sub><b>Anthony Conrad</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=parithon" title="Code">💻</a> <a href="#ideas-parithon" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=parithon" title="Documentation">📖</a></td><td align="center"><a href="https://millerb.co.uk"><img src="https://avatars0.githubusercontent.com/u/24279339?v=4" width="100px;" alt="Brett Miller"/><br /><sub><b>Brett Miller</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=brettmillerb" title="Code">💻</a> <a href="#ideas-brettmillerb" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=brettmillerb" title="Documentation">📖</a></td><td align="center"><a href="https://github.com/corbob"><img src="https://avatars2.githubusercontent.com/u/30301021?v=4" width="100px;" alt="corbob"/><br /><sub><b>corbob</b></sub></a><br /><a href="#ideas-corbob" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=corbob" title="Code">💻</a></td><td align="center"><a href="https://c-j.tech"><img src="https://avatars0.githubusercontent.com/u/3969086?v=4" width="100px;" alt="Chris Jones"/><br /><sub><b>Chris Jones</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=cmjchrisjones" title="Documentation">📖</a></td><td align="center"><a href="https://www.ramblinggeek.co.uk"><img src="https://avatars3.githubusercontent.com/u/7108949?v=4" width="100px;" alt="Wayne Taylor"/><br /><sub><b>Wayne Taylor</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=RamblingGeekUK" title="Code">💻</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=RamblingGeekUK" title="Documentation">📖</a></td></tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->
