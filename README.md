# PowerShell Alias
[![All Contributors](https://img.shields.io/badge/all_contributors-6-orange.svg?style=flat-square)](#contributors)

For more information as to how this repo came about, check out this [blog post](https://michaeljolley.com/posts/setup-command-aliases-in-powershell-to-make-life-easier/)

PowerShell scripts that enables shorthand for common commands for Docker, Git, and more.

<p align="center">
    <img src="https://user-images.githubusercontent.com/1228996/57589863-f307f680-74ec-11e9-91fd-a9bd07bcbb7c.png"/>
</p>

## Parameters

All aliases accept parameters of the commands they call.

For example, the below are identical:

```
g cl https://github.com/MichaelJolley/ps-alias.git

git clone https://github.com/MichaelJolley/ps-alias.git
```

## Commands

### Docker

All aliases for Docker begin with `d`.

| Command   | Executes
| ---       | ---
| d b       | docker build
| d c       | docker container ps
| d cr      | docker container rm
| d cs      | docker container start
| d cx      | docker container stop
| d i       | docker image ls
| d ir      | docker image rm
| d k       | docker kill
| d l       | docker logs
| d li      | docker login
| d lo      | docker logout
| d r       | docker run
| d t       | docker image tag
| d p       | docker push
| d ...     | docker ... (where ... is any parameter you use)


### Git

All aliases for Git begin with `g`.

| Command   | Executes
| ---       | ---
| g a       | git add
| g b       | git branch
| g c       | git checkout
| g cl      | git clone
| g co      | git commit
| g f       | git fetch
| g i       | git init
| g m       | git merge
| g pl      | git pull
| g ps      | git push
| g r       | git rebase
| g rs      | git reset
| g s       | git status
| g t       | git tag
| g ...     | git ... (where ... is any parameter you use)

### Miscellaneous

| Command                           | Executes
| ---                               | ---
| gh                                | Launches browser to GitHub repo if the directory is tracked by Git and its origin url is at GitHub
| reload                            | Restarts PowerShell in-place. Useful in the event you have added something to the path or user profile script and need a powershell restart in order for it to be recognized.
| hosts                             | Opens the hosts file in VS Code
| Syntax                            | Prints PowerShell Command Syntax vertically, replicating docs.microsoft.com layout
| Sort-Reverse                      | Reverses the order of an array. Accepts pipeline support e.g. `1,2,3,4,5 | Sort-Reverse`
| Restore-WorkspacePackages (rwp)   | Restores NPM, Nuget, and Libman packages starting at the root folder of a workspace.


## Contributing

Want to contribute? Check out our [Code of Conduct](CODE_OF_CONDUCT.md) and [Contributing](CONTRIBUTING.md) docs. This project follows the [all-contributors](https://github.com/all-contributors/all-contributors) specification.  Contributions of any kind welcome!

Thanks goes to these wonderful people ([emoji key](https://allcontributors.org/docs/en/emoji-key)):

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore -->
<table><tr><td align="center"><a href="https://michaeljolley.com/"><img src="https://avatars2.githubusercontent.com/u/1228996?v=4" width="100px;" alt="Michael Jolley"/><br /><sub><b>Michael Jolley</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=MichaelJolley" title="Code">💻</a> <a href="#ideas-MichaelJolley" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=MichaelJolley" title="Documentation">📖</a></td><td align="center"><a href="http://ryanhayes.net"><img src="https://avatars3.githubusercontent.com/u/438357?v=4" width="100px;" alt="Ryan Hayes"/><br /><sub><b>Ryan Hayes</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=RyannosaurusRex" title="Code">💻</a> <a href="#ideas-RyannosaurusRex" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=RyannosaurusRex" title="Documentation">📖</a></td><td align="center"><a href="https://github.com/parithon"><img src="https://avatars3.githubusercontent.com/u/8602418?v=4" width="100px;" alt="Anthony Conrad"/><br /><sub><b>Anthony Conrad</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=parithon" title="Code">💻</a> <a href="#ideas-parithon" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=parithon" title="Documentation">📖</a></td><td align="center"><a href="https://millerb.co.uk"><img src="https://avatars0.githubusercontent.com/u/24279339?v=4" width="100px;" alt="Brett Miller"/><br /><sub><b>Brett Miller</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=brettmillerb" title="Code">💻</a> <a href="#ideas-brettmillerb" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=brettmillerb" title="Documentation">📖</a></td><td align="center"><a href="https://github.com/corbob"><img src="https://avatars2.githubusercontent.com/u/30301021?v=4" width="100px;" alt="corbob"/><br /><sub><b>corbob</b></sub></a><br /><a href="#ideas-corbob" title="Ideas, Planning, & Feedback">🤔</a> <a href="https://github.com/MichaelJolley/ps-alias/commits?author=corbob" title="Code">💻</a></td><td align="center"><a href="https://c-j.tech"><img src="https://avatars0.githubusercontent.com/u/3969086?v=4" width="100px;" alt="Chris Jones"/><br /><sub><b>Chris Jones</b></sub></a><br /><a href="https://github.com/MichaelJolley/ps-alias/commits?author=cmjchrisjones" title="Documentation">📖</a></td></tr></table>

<!-- ALL-CONTRIBUTORS-LIST:END -->

