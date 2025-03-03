# The Docker Handbook

*Notes and examples from [The Docker Handbook](https://www.freecodecamp.org/news/the-docker-handbook/) by [Farhan Chowdhury](https://twitter.com/frhnhsin)*

## Introduction

### Container Runtime

The container runtime (Docker) sites between the containers and the host operating system.  As a demonstration, enter the following into a terminal:

```bash
uname -a
# Linux HOSTNAME 5.4.72-microsoft-standard-WSL2 #1 SMP Wed Oct 28 23:40:43 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux

docker run alpine uname -a
# Unable to find image 'alpine:latest' locally
# latest: Pulling from library/alpine
# 540db60ca938: Pull complete
# Digest: sha256:69e70a79f2d41ab5d637de98c1e0b055206ba40a8145e7bddb55ccc04e13cf8f
# Status: Downloaded newer image for alpine:latest
# Linux 7cf4cf5e1253 5.4.72-microsoft-standard-WSL2 #1 SMP Wed Oct 28 23:40:43 UTC 2020 x86_64 Linux
```

This shows [Ubuntu](https://ubuntu.com/blog/ubuntu-on-wsl-2-is-generally-available) (in my case) and [Alpine Linux](https://alpinelinux.org/) both using the WSL2 kernel.

### Images

Images are multi-layered, self-contained files that act as the template for creating containers. Containers are just images in a running state.

### Registry

A centralised image registry to upload and download images.

### Architecture

> "Docker uses a client-server architecture. The Docker *client* talks to the Docker *daemon*, which does the heavy lifting of building, running, and distributing your Docker containers" [*Docker documentation*](https://docs.docker.com/get-started/overview/#docker-architecture)

## Working with Containers

### Detached Mode

To run a container as a background process, simply use the `--detach` or `-d` option.

```bash
docker container run --detach --publish 8080:80 fhsinchy/hello-dock
```

Alternatively, the `container start` command starts any container in detached mode by default and also retains any port configurations made previously.

```shell
docker container start hello-dock-container
```

### List Containers

List running containers with:

```bash
# currently running
docker container ls

# include containers that have run in the past
docker container ls -all # -a
```

### Rename a Container

Containers have two identifiers:

- CONTAINER ID; a random 64 char string
- NAME; two random words, joined with an underscore

Specify a name for new containers with `--name`, for example, to run `fhsinchy/hello-dock` with the name `hello-dock-container`.

```bash
docker container run --detach --publish 8888:80 --name hello-dock-container fhsinchy/hello-dock
```

To rename an existing container.

```bash
# docker container rename <container identifier> <new name>
docker container rename gifted_sammet hello-dock-container-2
```

### Stop or Kill a Running Container

The `stop` command attempts to shutdown a container gracefully by sending a `SIGTERM` signal.  After a certain period, a `SIGKILL` signal is sent which shuts down the container immediately.

```bash
# docker container stop <container identifier>
docker container stop hello-dock-container
```

Alternatively to send a `SIGKILL` immediately

```shell
docker container kill hello-dock-container
```

### Restart a Container

To restart a running container:

```shell
docker container restart hello-dock-container
```

### Create a Container Without Running

Use `container create` to create a container from a given image.  You can then use `container start` to run.

```shell
docker container create --publish 8080:80 fhsinchy/hello-dock
```

### Remove Old Containers

Containers that have been stopped or killed remain in the system.  These dangling containers take up space and can conflict with newer containers.

```shell
docker container rm <container identifier>
```

Alternatively, you can remove all dangling containers in one go with

```shell
docker container prune
```

### Interactive Mode

Some images are pre-configured to run a shell by default, be that `sh`, `bash` or a default language shell.  This can be accessed with the `-it` option:

```shell
docker container run -it ubuntu

# Unable to find image 'ubuntu:latest' locally
# latest: Pulling from library/ubuntu
# 345e3491a907: Pull complete
# 57671312ef6f: Pull complete
# 5e9250ddb7d0: Pull complete
# Digest: sha256:cf31af331f38d1d7158470e095b132acd126a7180a54f263d386da88eb681d93
# Status: Downloaded newer image for ubuntu:latest
# root@250fd7351d58:/# ls -la
# total 56
# drwxr-xr-x   1 root root 4096 Apr 28 10:33 .
# drwxr-xr-x   1 root root 4096 Apr 28 10:33 ..
# -rwxr-xr-x   1 root root    0 Apr 28 10:33 .dockerenv
```

The `-it` option allows interaction with the underlying containers shell.  This is actually two options, used together.

- The `-i` or `--interactive` option connects to the input stream of the container, so you can send inputs to bash.
- The `-t` or `--tty` option allocates a pseudo tty to ensure a terminal like experience.

### Execute Commands

To execute a certain command inside a certain container.

```bash
# docker container run <image name> <command>

docker container run --rm busybox echo -n my-secret | base64

# bXktc2VjcmV0
```

### Bind Mounts and Executable Images

Images can be configured to have an entry point set to a custom program instead of a shell.  This example runs a script on a /zone directory inside the container.  As containers are isolated from the host system this only becomes useful when using [bind mounts](https://docs.docker.com/storage/bind-mounts/).

A bind mount forms a binding between a local (source) and container (destination) directory.

```shell
# --volume <local file system directory absolute path>:<container file system directory absolute path>:<read write access>

docker container run --rm -v $(pwd):/zone fhsinchy/rmbyext pdf
```

## Working with Images

### Dockerfile

Create Dockerfiles in [Visual Studio Code](https://code.visualstudio.com/) with the [Docker Extension](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker).

In an empty directory, create a new file named `Dockerfile`.

```dockerfile
# Set the base image, in this instance the latest availible version of Ubuntu
FROM ubuntu:latest

# Indicate ports that need to be published.  Not a replacement for --publish
EXPOSE 80

# Executes commands inside the container shell, written as shell or exec
RUN apt-get update && \ 
    apt-get install nginx -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
# apt-get clean && rm -rf /var/lib/apt/lists/*
# clears the package cache, keepping the image clean

# Default command for the image, written as shell or exec
CMD ["nginx", "-g", "daemon off;"]
# Here, 'nginx' referes to the NGINX executable, ''-g' and 'daemon off' are parameters

# Note: Running NGINX as a single process inside containers is considered best practise.
```

To build an image from the `Dockerfile`.

```shell
# docker image <command> <options>

docker image build .

# [+] Building 24.0s (6/6) FINISHED
# => [internal] load build definition from Dockerfile                                                               0.2s
# => => transferring dockerfile: 220B                                                                               0.0s
# => [internal] load .dockerignore                                                                                  0.2s
# => => transferring context: 2B                                                                                    0.0s
# => [internal] load metadata for docker.io/library/ubuntu:latest                                                   0.0s
# => [1/2] FROM docker.io/library/ubuntu:latest                                                                     0.1s
# => [2/2] RUN apt-get update &&     apt-get install nginx -y &&     apt-get clean && rm -rf /var/lib/apt/lists/*  22.8s
# => exporting to image                                                                                             0.7s
# => => exporting layers                                                                                            0.6s
# => => writing image sha256:aa85f745f365ae57a966387293223f426af55438d5eb3c3d1f651fda2e7bdcfa                       0.0s
```

Rather than use the sha256 ID, in a PowerShell terminal.

```powershell
 docker image ls | Select -First 2
 
 # REPOSITORY                         TAG            IMAGE ID       CREATED             SIZE
# <none>                             <none>         aa85f745f365   About an hour ago   132MB
```

Run the container image using the supplied ID.

```shell
docker container run --rm --detach --name custom-nginx-packaged --publish 8080:80 aa85f745f365

docker container ls

# CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS         PORTS                  NAMES
# ea892fb9ecf3   aa85f745f365   "nginx -g 'daemon of…"   10 seconds ago   Up 8 seconds   0.0.0.0:8080->80/tcp   custom-nginx-packaged
```

Verify by pointing a browser to http://localhost:8080

### Tagging

To assign custom identifiers (tags).

```shell
# --tag <image repository>:<image tag>

docker image build --tag custom-nginx:packaged .
```

*Note: The repository is usually known as the image name and the tag indicates build or version.*

To tag an existing image.

```shell
docker image tag <image id> <image repository>:<image tag>

## or ##

docker image tag <image repository>:<image tag> <new image repository>:<new image tag>
```

### List and Remove

Similar to container commands.

```shell
docker image ls

docker image rm <image identifier>

docker image rm custom-nginx:packaged
```

You can also use (with caution) the prune command.

```shell
docker image prune --force
```

### Layers

Images are multi-layered files, this can be seen with the `history` command.

```shell
docker image history custom-nginx:packaged

# IMAGE          CREATED        CREATED BY                                      SIZE      COMMENT
# aa85f745f365   19 hours ago   CMD ["nginx" "-g" "daemon off;"]                0B        buildkit.dockerfile.v0
# <missing>      19 hours ago   RUN /bin/sh -c apt-get update &&     apt-get…   59.2MB    buildkit.dockerfile.v0
# <missing>      19 hours ago   EXPOSE map[80/tcp:{}]                           0B        buildkit.dockerfile.v0
# <missing>      7 days ago     /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
# <missing>      7 days ago     /bin/sh -c mkdir -p /run/systemd && echo 'do…   7B
# <missing>      7 days ago     /bin/sh -c [ -z "$(apt-get indextargets)" ]     0B
# <missing>      7 days ago     /bin/sh -c set -xe   && echo '#!/bin/sh' > /…   811B
# <missing>      7 days ago     /bin/sh -c #(nop) ADD file:5c44a80f547b7d68b…   72.7MB
```

An image comprises of many read-only layers, each recording a new set of changes to the state.  When starting a container you add a new writable layer.  This is based on the concept of union in set theory.

> It allows files and directories of separate file systems, known as branches, to be transparently overlaid, forming a single coherent file system. Contents of directories which have the same path within the merged branches will be seen together in a single merged directory, within the new, virtual filesystem.
>
> Source: [Wikipedia](https://en.wikipedia.org/wiki/UnionFS)

### Optimising

Remove packages required for building but not running.  Modify the NGINX from Source Dockerfile 

```dockerfile
FROM ubuntu:latest

EXPOSE 80

ARG FILENAME="nginx-1.19.2"
ARG EXTENSION="tar.gz"

ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .

RUN apt-get update && \
    apt-get install build-essential \ 
                    libpcre3 \
                    libpcre3-dev \
                    zlib1g \
                    zlib1g-dev \
                    libssl1.1 \
                    libssl-dev \
                    -y && \
    tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION} && \
    cd ${FILENAME} && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install && \
    cd / && rm -rfv /${FILENAME} && \
    apt-get remove build-essential \ 
                    libpcre3-dev \
                    zlib1g-dev \
                    libssl-dev \
                    -y && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]
```

The `RUN apt-get....` command is now doing a lot more.  If you install packages and then remove them in separate RUN instructions they will create separate layers within the image.  Although the final image won't have the removed packages, they will still exist in the layers comprising the image.

Moving to Alpine Linux can also save space as the base image comes in at 2.8 MB.

```dockerfile
FROM alpine:latest

EXPOSE 80

ARG FILENAME="nginx-1.19.2"
ARG EXTENSION="tar.gz"

ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .

RUN apk add --no-cache pcre zlib && \
    apk add --no-cache \
            --virtual .build-deps \
            build-base \ 
            pcre-dev \
            zlib-dev \
            openssl-dev && \
    tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION} && \
    cd ${FILENAME} && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install && \
    cd / && rm -rfv /${FILENAME} && \
    apk del .build-deps

CMD ["nginx", "-g", "daemon off;"]
```

Changes from Ubuntu:

- Instead of `apt-get install`, we now use `apk add`.  The `--no-cache` option prevents caching of downloaded packages.  
- The `--virtual` option is used to bundle packages into a single virtual package.  Packages that are only required for building the program are labelled with `.build-deps` for easier removal later.

```shell
docker image build --tag custom-nginx:built .
```

### Executable Images

To create an image to run `rmbyext` automatically:

```dockerfile
FROM python:3-alpine

WORKDIR /zone

RUN apk add --no-cache git && \
    pip install git+https://github.com/fhsinchy/rmbyext.git#egg=rmbyext && \
    apk del git

ENTRYPOINT [ "rmbyext" ]
```

- The `FROM` instruction uses a [Python](https://hub.docker.com/_/python) base image.  The `3-alpine` tag indicates we are using the Alpine version
- The `WORKDIR` instruction sets the default working directory to /zone.  This is arbitrary and can be set to anything
- The `RUN` command installs git, which is then used to install rmbyext via pip
- The `ENTRYPOINT` instruction sets the `rmbyext` script as the entry-point for the image

```shell
docker image build --tag rmbyext .
```

To run on Linux

```shell
docker container run --rm -v $(pwd):/zone rmbyext pdf
```

To run in PS

```shell
docker container run --rm -v ${PWD}:/zone rmbyext pdf
```

### Sharing

*Requires an account with [Docker Hub](https://hub.docker.com/)*

Log in with the CLI:

```shell
docker login

# Login with your Docker ID to push and pull images from Docker Hub...
#...
# Login Succeeded
```

To share online an image needs to be tagged:

```shell
--tag <image repository>:<image tag>
```

For example:

```shell
# fhsinchy is the username

docker image build --tag fhsinchy/custom-nginx:latest --file Dockerfile.built .

# Push to hub
# docker image push <image repository>:<image tag>
docker image push fhsinchy/custom-nginx:latest
```



## Examples

### Hello World

With Docker installed, open a terminal and run the following:

```bash
docker run hello-world

# Unable to find image 'hello-world:latest' locally
# latest: Pulling from library/hello-world
# b8dfde127a29: Pull complete
# Digest: sha256:f2266cbfc127c960fd30e76b7c792dc23b588c0db76233517e1891a4e357d519
# Status: Downloaded newer image for hello-world:latest

# Hello from Docker!
# This message shows that your installation appears to be working correctly.

# To generate this message, Docker took the following steps:
#  1. The Docker client contacted the Docker daemon.
#  2. The Docker daemon pulled the "hello-world" image from the Docker Hub. (amd64)
#  3. The Docker daemon created a new container from that image which runs the executable that produces the output you are currently reading.
#  4. The Docker daemon streamed that output to the Docker client, which sent it to your terminal.

# To try something more ambitious, you can run an Ubuntu container with:
#  $ docker run -it ubuntu bash

# Share images, automate workflows, and more with a free Docker ID:
#  https://hub.docker.com/

# For more examples and ideas, visit:
#  https://docs.docker.com/get-started/
```

The [Hello World!](https://hub.docker.com/_/hello-world) image is an example of minimal containerization with Docker.

Run `docker ps -a` in a terminal to see current and past containers that have run on the system:

```bash
docker ps -a
# CONTAINER ID   IMAGE                              COMMAND                  CREATED         STATUS                     PORTS                                            NAMES
# 1abb22b58e7d   hello-world                        "/hello"                 5 minutes ago   Exited (0) 5 minutes ago                   
```

### Hello Dock

This image contains a simple Vue.js application running on port 80 (container) which is published as 8080 (host).

```bash
docker container run --publish 8080:80 fhsinchy/hello-dock

# Unable to find image 'fhsinchy/hello-dock:latest' locally
# latest: Pulling from fhsinchy/hello-dock
# 0a6724ff3fcd: Pull complete
# ...
# /docker-entrypoint.sh: Configuration complete; ready for start up
```

To allow access into a container, you must map host and container ports.  The example above forwards any requests to 8080 on the host system to 80 inside the container.

To access the application, visit `http://127.0.0.1:8080/` in a browser.

### NGINX on Ubuntu

```dockerfile
FROM ubuntu:latest

EXPOSE 80

RUN apt-get update && \ 
    apt-get install nginx -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

CMD ["nginx", "-g", "daemon off;"]
```

### NGINX from Source on Ubuntu

```dockerfile
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install build-essential\ 
                    libpcre3 \
                    libpcre3-dev \
                    zlib1g \
                    zlib1g-dev \
                    libssl1.1 \
                    libssl-dev \
                    -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY nginx-1.19.2.tar.gz .

RUN tar -xvf nginx-1.19.2.tar.gz && rm nginx-1.19.2.tar.gz

RUN cd nginx-1.19.2 && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install

RUN rm -rf /nginx-1.19.2

CMD ["nginx", "-g", "daemon off;"]
```

Run a container using the `custom-nginx:built` tag

```shell
docker container run --rm --detach --name custom-nginx-built --publish 8080:80 custom-nginx:built

# 98cc8fa65d44f4b04368c5408955debdd7debd13db07ab94f475861ccb10d9a2

docker container ls
# CONTAINER ID   IMAGE                COMMAND                  CREATED          STATUS          PORTS                  NAMES
# 98cc8fa65d44   custom-nginx:built   "nginx -g 'daemon of…"   19 seconds ago   Up 18 seconds   0.0.0.0:8080->80/tcp   custom-nginx-built
```

To access the application, visit `http://127.0.0.1:8080/` in a browser.

### NGINX from Source on Alpine

```dockerfile
FROM alpine:latest

EXPOSE 80

ARG FILENAME="nginx-1.19.2"
ARG EXTENSION="tar.gz"

ADD https://nginx.org/download/${FILENAME}.${EXTENSION} .

RUN apk add --no-cache pcre zlib && \
    apk add --no-cache \
            --virtual .build-deps \
            build-base \ 
            pcre-dev \
            zlib-dev \
            openssl-dev && \
    tar -xvf ${FILENAME}.${EXTENSION} && rm ${FILENAME}.${EXTENSION} && \
    cd ${FILENAME} && \
    ./configure \
        --sbin-path=/usr/bin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --with-pcre \
        --pid-path=/var/run/nginx.pid \
        --with-http_ssl_module && \
    make && make install && \
    cd / && rm -rfv /${FILENAME} && \
    apk del .build-deps

CMD ["nginx", "-g", "daemon off;"]
```

```shell
docker image build --tag custom-nginx:built .
```

### Executable Image

```dockerfile
FROM python:3-alpine

WORKDIR /zone

RUN apk add --no-cache git && \
    pip install git+https://github.com/fhsinchy/rmbyext.git#egg=rmbyext && \
    apk del git

ENTRYPOINT [ "rmbyext" ]
```

```shell
docker image build --tag rmbyext .
```

