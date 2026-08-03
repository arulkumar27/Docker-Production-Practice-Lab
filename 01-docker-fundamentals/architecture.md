# Docker Architecture

Docker uses a client-server architecture.

## Main Components

### Docker Client

The Docker client accepts commands entered by the user.

Examples:

```bash
docker pull nginx:alpine
docker build -t my-application:v1 .
docker run -d nginx:alpine
docker ps
```

The client sends API requests to the Docker daemon.

### Docker Daemon

The Docker daemon runs as a background service and performs operations such as:

- Building images
- Pulling and pushing images
- Creating containers
- Starting and stopping containers
- Managing networks
- Managing volumes

The daemon process is usually called `dockerd`.

Check its status on Linux:

```bash
sudo systemctl status docker
```

### Docker Host

The Docker host is the machine on which Docker Engine is running.

Examples:

- Developer laptop
- Physical Linux server
- AWS EC2 instance
- Virtual machine
- CI/CD build agent

The host stores and manages Docker images, containers, networks, and volumes.

### Docker Registry

A registry stores and distributes container images.

Common registries include:

- Docker Hub
- Amazon Elastic Container Registry
- GitHub Container Registry
- Azure Container Registry
- Google Artifact Registry

Pull an image:

```bash
docker pull nginx:alpine
```

Push an image:

```bash
docker push username/application:v1
```

### Docker Image

An image is an immutable application package containing:

- Application code
- Runtime
- Libraries
- Dependencies
- Configuration defaults
- Filesystem layers

Images are used to create containers.

### Docker Container

A container is a running or stopped instance of an image.

A container receives its own:

- Process space
- Filesystem layer
- Network interface
- Environment variables
- Resource configuration

Containers share the kernel of the host operating system.

## Command Execution Flow

When the following command is executed:

```bash
docker run -d --name web nginx:alpine
```

Docker performs these actions:

1. The Docker client sends the request to the daemon.
2. The daemon checks whether `nginx:alpine` exists locally.
3. If it is unavailable locally, the daemon pulls it from the registry.
4. Docker creates a writable container layer.
5. Docker configures networking and storage.
6. Docker starts the Nginx process.
7. The container continues running while its main process is active.

## Docker Engine Components

Docker Engine mainly contains:

- Docker CLI
- Docker daemon
- Docker API
- `containerd`
- `runc`

### containerd

`containerd` manages the container lifecycle, image transfers, and container storage.

### runc

`runc` is a low-level runtime that creates and starts containers using operating-system isolation features.

## Linux Isolation Technologies

Docker uses Linux kernel features such as:

### Namespaces

Namespaces isolate resources including:

- Processes
- Networks
- Mount points
- Hostnames
- Users

### Control Groups

Control groups, also called cgroups, control and measure:

- CPU usage
- Memory usage
- Process limits
- Device access

Example resource restrictions:

```bash
docker run -d \
  --name limited-nginx \
  --memory="256m" \
  --cpus="0.50" \
  nginx:alpine
```

## Useful Inspection Commands

Display Docker system information:

```bash
docker info
```

Display Docker versions:

```bash
docker version
```

List images:

```bash
docker image ls
```

List running containers:

```bash
docker container ls
```

List Docker networks:

```bash
docker network ls
```

List Docker volumes:

```bash
docker volume ls
```

Display Docker disk usage:

```bash
docker system df
```
