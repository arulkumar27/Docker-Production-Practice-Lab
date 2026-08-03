# Docker Installation

This guide installs Docker Engine and the Docker Compose plugin on an Ubuntu system.

## Supported Environment

- Ubuntu Server
- Ubuntu Desktop
- AWS EC2 running Ubuntu

## Remove Conflicting Packages

```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y "$pkg"
done
```

It is normal if some packages are not installed.

## Configure the Docker Repository

Update the package index and install prerequisites:

```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl
```

Create the keyring directory:

```bash
sudo install -m 0755 -d /etc/apt/keyrings
```

Download Docker’s signing key:

```bash
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
```

Allow the package manager to read the key:

```bash
sudo chmod a+r /etc/apt/keyrings/docker.asc
```

Add the Docker repository:

```bash
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" |
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

Update the package index:

```bash
sudo apt-get update
```

## Install Docker

```bash
sudo apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin
```

## Start and Enable Docker

```bash
sudo systemctl enable --now docker
```

Verify the service:

```bash
sudo systemctl status docker
```

Press `q` to exit the service-status screen.

## Verify Installation

```bash
sudo docker version
sudo docker info
sudo docker run --rm hello-world
```

The `--rm` option automatically removes the test container after it exits.

## Run Docker Without sudo

Add the current user to the Docker group:

```bash
sudo usermod -aG docker "$USER"
```

Apply the new group membership:

```bash
newgrp docker
```

Verify access:

```bash
docker ps
docker run --rm hello-world
```

### Command Explanation

```bash
sudo usermod -aG docker "$USER"
```

- `sudo`: runs the command with administrator privileges
- `usermod`: modifies a user account
- `-a`: appends the user to an additional group
- `-G`: specifies the supplementary group
- `docker`: the target group
- `$USER`: the currently logged-in user

Adding a user to the Docker group provides powerful host-level access. Only trusted users should receive this permission.

## Verify Docker Compose

```bash
docker compose version
```

Use the modern command:

```bash
docker compose
```

The older standalone syntax is:

```bash
docker-compose
```

## Test with Nginx

```bash
docker run -d \
  --name installation-test \
  -p 8080:80 \
  nginx:alpine
```

Check the container:

```bash
docker ps
docker logs installation-test
```

Test locally:

```bash
curl http://localhost:8080
```

Clean up:

```bash
docker stop installation-test
docker rm installation-test
```

## Common Problems

### Permission Denied

Example:

```text
permission denied while trying to connect to the Docker daemon socket
```

Check group membership:

```bash
groups
```

Apply the group:

```bash
newgrp docker
```

If required, sign out and sign back in.

### Docker Daemon Is Not Running

```bash
sudo systemctl start docker
sudo systemctl enable docker
sudo systemctl status docker
```

### Port Is Already Allocated

Find the container using the port:

```bash
docker ps
```

Use a different host port:

```bash
docker run -d --name alternate-nginx -p 8081:80 nginx:alpine
```

### Website Not Opening on EC2

Check the following:

- The container is running
- The port is published correctly
- The EC2 security group permits the required inbound port
- The application listens on the expected container port
- The operating-system firewall is not blocking traffic

Test from inside EC2:

```bash
curl http://localhost:8080
```
