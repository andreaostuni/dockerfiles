# althack/ignition

These are the docker images I use for developing with [VSCode](https://code.visualstudio.com/).
See [the docs](https://andreaostuni.github.io/dockerfiles) or read about  [how I develop with vscode and docker](https://www.allisonthackston.com/articles/docker_development.html).

## Usage

```bash
docker pull andreaostuni/ignition:fortress-base
```

## Organization

The main docker image tags are:

* [fortress-base](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/fortress.Dockerfile)
* [fortress-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/fortress.Dockerfile)
* [fortress-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/fortress.Dockerfile)
* [edifice-base](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/edifice.Dockerfile) (eol)
* [edifice-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/edifice.Dockerfile) (eol)
* [edifice-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/edifice.Dockerfile) (eol)
* [dome-base](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/dome.Dockerfile)
* [dome-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/dome.Dockerfile)
* [dome-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/dome.Dockerfile)
* [citadel-base](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/citadel.Dockerfile)
* [citadel-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/citadel.Dockerfile)
* [citadel-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ignition/citadel.Dockerfile)

Each image is additionally tagged with the date of creation, which lets you peg to a specific version of packages.

The format is {image-name}-{year}-{month}-{day}