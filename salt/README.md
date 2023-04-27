# althack/salt

These are the docker images I use for developing with [VSCode](https://code.visualstudio.com/).
See [the docs](https://andreaostuni.github.io/dockerfiles) or read about  [how I develop with vscode and docker](https://www.allisonthackston.com/articles/docker_development.html).

## Usage

```bash
docker pull andreaostuni/salt:salt-cuda-11.8-base
```

## Organization

The main docker image tags are:

* [salt-cuda-11.8-base](https://github.com/andreaostuni/dockerfiles/blob/main/salt/salt-cuda-11.8.Dockerfile)

Each image is additionally tagged with the date of creation, which lets you peg to a specific version of packages.

The format is {image-name}-{year}-{month}-{day}