# althack/ros2

These are the docker images I use for developing with [VSCode](https://code.visualstudio.com/).
See [the docs](https://andreaostuni.github.io/dockerfiles) or read about  [how I develop with vscode and docker](https://www.allisonthackston.com/articles/docker_development.html).

## Usage

```bash
docker pull andreaostuni/ros2:rolling-base
```

## Organization

The main docker image tags are:

* [rolling-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling.Dockerfile)
* [rolling-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling.Dockerfile)
* [rolling-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling.Dockerfile)
* [rolling-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling.Dockerfile)
* [rolling-egl-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling-egl.Dockerfile)
* [rolling-egl-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling-egl.Dockerfile)
* [rolling-egl-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling-egl.Dockerfile)
* [rolling-egl-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/rolling-egl.Dockerfile)
* [humble-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble.Dockerfile)
* [humble-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble.Dockerfile)
* [humble-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble.Dockerfile)
* [humble-gazebo](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble.Dockerfile)
* [humble-cuda-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda.Dockerfile)
* [humble-cuda-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda.Dockerfile)
* [humble-cuda-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda.Dockerfile)
* [humble-cuda-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda.Dockerfile)
* [humble-egl-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl.Dockerfile)
* [humble-egl-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl.Dockerfile)
* [humble-egl-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl.Dockerfile)
* [humble-egl-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl.Dockerfile)
* [humble-egl-cuda11.8-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-cuda11.8.Dockerfile)
* [humble-egl-cuda11.8-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-cuda11.8.Dockerfile)
* [humble-egl-cuda11.8-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-cuda11.8.Dockerfile)
* [humble-egl-cuda11.8-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-cuda11.8.Dockerfile)
* [humble-arm64-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-arm64.Dockerfile)
* [humble-arm64-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-arm64.Dockerfile)
* [humble-egl-garden-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-garden.Dockerfile)
* [humble-egl-garden-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-garden.Dockerfile)
* [humble-egl-garden-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-garden.Dockerfile)
* [humble-egl-garden-gz_sim-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-garden.Dockerfile)
* [humble-egl-fortress-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-fortress.Dockerfile)
* [humble-egl-fortress-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-fortress.Dockerfile)
* [humble-egl-fortress-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-fortress.Dockerfile)
* [humble-egl-fortress-gz_sim-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-egl-fortress.Dockerfile)
* [humble-ign-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-ign.Dockerfile)
* [humble-ign-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-ign.Dockerfile)
* [humble-ign-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-ign.Dockerfile)
* [humble-ign-gz_sim](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-ign.Dockerfile)
* [humble-cuda-ign-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda-ign.Dockerfile)
* [humble-cuda-ign-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda-ign.Dockerfile)
* [humble-cuda-ign-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda-ign.Dockerfile)
* [humble-cuda-ign-gz_sim-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/humble-cuda-ign.Dockerfile)
* [galactic-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic.Dockerfile)
* [galactic-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic.Dockerfile)
* [galactic-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic.Dockerfile)
* [galactic-gazebo](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic.Dockerfile)
* [galactic-cuda-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic-cuda.Dockerfile)
* [galactic-cuda-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic-cuda.Dockerfile)
* [galactic-cuda-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic-cuda.Dockerfile)
* [galactic-cuda-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/galactic-cuda.Dockerfile)
* [foxy-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy.Dockerfile)
* [foxy-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy.Dockerfile)
* [foxy-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy.Dockerfile)
* [foxy-gazebo](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy.Dockerfile)
* [foxy-cuda-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-cuda.Dockerfile)
* [foxy-cuda-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-cuda.Dockerfile)
* [foxy-cuda-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-cuda.Dockerfile)
* [foxy-cuda-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-cuda.Dockerfile)
* [foxy-egl-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl.Dockerfile)
* [foxy-egl-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl.Dockerfile)
* [foxy-egl-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl.Dockerfile)
* [foxy-egl-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl.Dockerfile)
* [foxy-egl-bridge-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-bridge.Dockerfile)
* [foxy-egl-bridge-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-bridge.Dockerfile)
* [foxy-egl-bridge-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-bridge.Dockerfile)
* [foxy-egl-bridge-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-bridge.Dockerfile)
* [foxy-egl-cuda11.8-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-cuda11.8.Dockerfile)
* [foxy-egl-cuda11.8-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-cuda11.8.Dockerfile)
* [foxy-egl-cuda11.8-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-cuda11.8.Dockerfile)
* [foxy-egl-cuda11.8-gazebo-nvidia](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/foxy-egl-cuda11.8.Dockerfile)
* [eloquent-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/eloquent.Dockerfile) (eol)
* [eloquent-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/eloquent.Dockerfile) (eol)
* [eloquent-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/eloquent.Dockerfile) (eol)
* [eloquent-gazebo](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/eloquent.Dockerfile) (eol)
* [dashing-base](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/dashing.Dockerfile) (eol)
* [dashing-dev](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/dashing.Dockerfile) (eol)
* [dashing-full](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/dashing.Dockerfile) (eol)
* [dashing-gazebo](https://github.com/andreaostuni/dockerfiles/blob/main/ros2/dashing.Dockerfile) (eol)

Each image is additionally tagged with the date of creation, which lets you peg to a specific version of packages.

The format is {image-name}-{year}-{month}-{day}