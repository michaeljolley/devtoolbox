<p align="center">
  <img src="https://user-images.githubusercontent.com/1228996/71608160-8fe2d700-2b44-11ea-99fc-a1d5674f74ef.png"/>
</p>

[![Downloads](https://img.shields.io/powershellgallery/dt/devtoolbox.svg)](https://www.powershellgallery.com/packages/devtoolbox)

# What & Why

For more information as to how this repo came about, check out this [blog post](https://baldbeardedbuilder.com/blog/adding-command-aliases-to-power-shell/)

---

## Installation

The easiest way to install devtoolbox is via the [PowerShell Gallery](https://www.powershellgallery.com/packages/devtoolbox).

```ps
Install-Module -Name devtoolbox
```

---

## Parameters

All aliases accept parameters of the commands they call.

For example, the below are identical:

```bash
g cl https://github.com/michaeljolley/devtoolbox.git

git clone https://github.com/michaeljolley/devtoolbox.git
```

---

## Commands

### Docker

All aliases for Docker begin with `d`.

| Command | Executes   |
| ------- | -------------------------- |
| d b   | docker build   |
| d c   | docker container ps  |
| d cr  | docker container rm  |
| d cs  | docker container start   |
| d cx  | docker container stop  |
| d i   | docker image ls  |
| d ir  | docker image rm  |
| d k   | docker kill  |
| d l   | docker logs  |
| d li  | docker login   |
| d lo  | docker logout  |
| d r   | docker run   |
| d t   | docker image tag   |
| d p   | docker push  |
| d ...   | docker ...(any parameters) |

### Docker-Compose

All aliases for Docker Compose begin with `dc`.

| Command | Executes   |
| ------- | ------------------------------------------------ |
| dc b  | docker-compose build   |
| dc bu   | docker-compose build (params); docker-compose up |
| dc d  | docker-compose down  |
| dc i  | docker-compose images  |
| dc u  | docker-compose up  |
| dc ...  | docker-compose ... (any parameters)  |

### Git

All aliases for Git begin with `g`.

| Command | Executes   |
| ------- | ------------------------ |
| g a   | git add  |
| g b   | git branch   |
| g c   | git checkout   |
| g cl  | git clone  |
| g co  | git commit   |
| g f   | git fetch  |
| g i   | git init   |
| g l   | git log  |
| g ll  | git log --graph (pretty) |
| g m   | git merge  |
| g pl  | git pull   |
| g ps  | git push   |
| g r   | git rebase   |
| g rs  | git reset  |
| g s   | git status   |
| g t   | git tag  |
| g ...   | git ... (any parameters) |

### Miscellaneous

| Command | Executes |
| --- | --- |
| github  | Launches browser to GitHub repo if the directory is tracked by Git and its origin url is at GitHub  |
| hosts   | If in Windows, opens the hosts file in an elevated editor. Choosing, in order, between VS Code, VS Code (insiders), Notepad.  |
| rwp | Restores NPM, Nuget, and Libman packages starting at the root folder of a workspace.  |
| Syntax  | Prints PowerShell Command Syntax vertically, replicating docs.microsoft.com layout  |
| Sort-Reverse  | Reverses the order of an array. Accepts pipeline support e.g. `1,2,3,4,5 | Sort-Reverse`  |

---

## Contributing

Want to contribute? Check out our [Code of Conduct](CODE_OF_CONDUCT.md) and [Contributing](CONTRIBUTING.md) docs. Contributions of any kind welcome!
