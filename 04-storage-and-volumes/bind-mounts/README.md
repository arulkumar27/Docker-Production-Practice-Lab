# Docker Bind Mount Practice

A bind mount maps a file or directory from the Docker host into a container.

Bind mounts are commonly used for:

- Local application development
- Static website files
- Application configuration
- Source-code synchronization
- Development logs
- Local testing

## Directory Structure

```text
bind-mounts/
├── README.md
└── html/
    └── index.html
```

## Linux and macOS Command

Run from the `bind-mounts` directory:

```bash
docker run -d \
  --name bind-mount-nginx \
  -p 8080:80 \
  --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html,readonly \
  nginx:alpine
```

## Windows PowerShell Command

Run from the `bind-mounts` directory:

```powershell
docker run -d `
  --name bind-mount-nginx `
  -p 8080:80 `
  --mount "type=bind,source=$($PWD.Path)\html,target=/usr/share/nginx/html,readonly" `
  nginx:alpine
```

## Verify the Container

```bash
docker ps
docker logs bind-mount-nginx
docker port bind-mount-nginx
```

## Test the Website

```bash
curl http://localhost:8080
```

Open in a browser:

```text
http://localhost:8080
```

For an AWS EC2 instance:

```text
http://EC2_PUBLIC_IP:8080
```

The EC2 security group must permit inbound TCP port `8080` from a trusted source.

## Inspect the Bind Mount

```bash
docker inspect \
  --format '{{json .Mounts}}' \
  bind-mount-nginx
```

The output should show:

- Type: `bind`
- Source: Host `html` directory
- Destination: `/usr/share/nginx/html`
- Read-only: `true`

## Test Real-Time Updates

Modify:

```text
html/index.html
```

Refresh the browser.

The changes appear immediately because Nginx reads the file from the mounted host directory.

The image does not need to be rebuilt.

## Test Read-Only Access

Try creating a file inside the mounted directory:

```bash
docker exec bind-mount-nginx \
  touch /usr/share/nginx/html/test.txt
```

The command should fail because the mount is read-only.

## Create a Writable Bind Mount

Remove the existing container:

```bash
docker rm -f bind-mount-nginx
```

Run without `readonly`:

```bash
docker run -d \
  --name writable-bind-nginx \
  -p 8080:80 \
  --mount type=bind,source="$(pwd)/html",target=/usr/share/nginx/html \
  nginx:alpine
```

Create a file from inside the container:

```bash
docker exec writable-bind-nginx \
  sh -c 'echo "Created from the container" > /usr/share/nginx/html/container.txt'
```

Check it from the host:

```bash
ls -la html
cat html/container.txt
```

The file should exist on the host because the mount is writable.

## Bind-Mount Security

A writable bind mount allows the container to modify files in the mounted host directory.

Recommendations:

- Use read-only mounts when write access is unnecessary
- Mount only the specific required path
- Avoid mounting sensitive system directories
- Do not mount the Docker socket into untrusted containers
- Validate file ownership and permissions

## Common Error: Source Path Does Not Exist

Verify your current location:

```bash
pwd
```

Check the directory:

```bash
ls -la html
```

With `--mount`, the bind-mount source must already exist.

## Cleanup

```bash
docker rm -f bind-mount-nginx writable-bind-nginx
```

If one container does not exist, Docker may display an error for that name.
