# 01 — Docker Fundamentals

This folder contains fundamental Docker concepts and basic hands-on commands required before working with Dockerfiles, networking, volumes, Docker Compose, and CI/CD pipelines.

## Learning Objectives

After completing this section, I will be able to:

- Explain why Docker is used
- Understand containers and images
- Explain Docker architecture
- Install and verify Docker
- Manage the container lifecycle
- Run and inspect containers
- View container logs and resource usage
- Stop, start, restart, and remove containers
- Understand the difference between containers and virtual machines

## What Is Docker?

Docker is a containerization platform used to package an application together with its runtime, libraries, dependencies, and configuration.

The packaged application can run consistently across different environments such as:

- Developer laptops
- Testing servers
- Staging environments
- Production servers
- Cloud virtual machines
- CI/CD build agents

## Why Docker Is Used

Without containers, applications may behave differently across environments because of:

- Different operating-system packages
- Missing dependencies
- Different runtime versions
- Incorrect environment variables
- Manual configuration differences

Docker reduces these problems by packaging the application and its required dependencies into an image.

## Core Docker Objects

| Object | Purpose |
|---|---|
| Dockerfile | Instructions used to build an image |
| Image | Read-only application package |
| Container | Running or stopped instance of an image |
| Registry | Storage location for images |
| Volume | Persistent storage for container data |
| Network | Communication layer between containers |
| Docker Compose | Defines and runs multi-container applications |

## Image vs Container

An image is a reusable application template.

A container is an executable instance created from that image.

Example:

```bash
docker pull nginx:alpine
docker run -d --name web-server nginx:alpine
```

In this example:

- `nginx:alpine` is the image
- `web-server` is the container

Multiple containers can be created from the same image.

## Container vs Virtual Machine

| Container | Virtual Machine |
|---|---|
| Shares the host OS kernel | Runs a complete guest OS |
| Starts quickly | Usually takes longer to start |
| Uses fewer resources | Uses more CPU, memory, and storage |
| Commonly measured in MB | Commonly measured in GB |
| Suitable for application services | Suitable for complete OS isolation |
| Managed using a container runtime | Managed using a hypervisor |

Containers do not replace virtual machines in every scenario. Containers are commonly run inside cloud virtual machines such as AWS EC2 instances.

## Practice Example

Run an Nginx web server:

```bash
docker run -d \
  --name fundamentals-nginx \
  -p 8080:80 \
  nginx:alpine
```

Open the following address in a browser:

```text
http://localhost:8080
```

For an EC2 instance, use:

```text
http://EC2_PUBLIC_IP:8080
```

The EC2 security group must allow inbound TCP traffic on port `8080` from a trusted source.

## Verify the Container

```bash
docker ps
docker logs fundamentals-nginx
docker inspect fundamentals-nginx
docker stats fundamentals-nginx
```

Press `Ctrl+C` to exit the live `docker stats` screen. This does not stop the container.

## Stop and Remove the Practice Container

```bash
docker stop fundamentals-nginx
docker rm fundamentals-nginx
```

Remove the image if it is no longer required:

```bash
docker image rm nginx:alpine
```

## Files in This Folder

| File | Description |
|---|---|
| `architecture.md` | Docker architecture and request flow |
| `installation.md` | Docker installation and verification |
| `container-lifecycle.md` | Container states and lifecycle commands |
| `basic-commands.md` | Common Docker commands with examples |

## Practice Checklist

- [ ] Understand image and container differences
- [ ] Explain Docker architecture
- [ ] Install Docker
- [ ] Run an Nginx container
- [ ] Publish a container port
- [ ] List containers and images
- [ ] View logs
- [ ] Inspect a container
- [ ] Monitor resource usage
- [ ] Stop and restart a container
- [ ] Remove a container and image
