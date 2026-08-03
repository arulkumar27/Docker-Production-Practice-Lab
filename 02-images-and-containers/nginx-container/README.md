# Nginx Container Practice

This exercise uses the official Nginx image to practise running, inspecting, modifying, and troubleshooting a container.

## Pull the Image

```bash
docker pull nginx:alpine
```

## Start Nginx

Run this command from the `nginx-container` directory:

```bash
docker run -d \
  --name nginx-practice \
  -p 8080:80 \
  nginx:alpine
```

## Verify the Container

```bash
docker ps
docker logs nginx-practice
docker port nginx-practice
```

Test the page:

```bash
curl http://localhost:8080
```

Browser address:

```text
http://localhost:8080
```

For AWS EC2:

```text
http://EC2_PUBLIC_IP:8080
```

The security group must allow inbound TCP port `8080` from a trusted source.

## Check Nginx Inside the Container

```bash
docker exec nginx-practice nginx -v
```

Open the container shell:

```bash
docker exec -it nginx-practice /bin/sh
```

Run these commands inside the container:

```sh
hostname
cat /etc/os-release
ls -la /usr/share/nginx/html
cat /usr/share/nginx/html/index.html
nginx -T
```

Exit:

```sh
exit
```

## Copy the Custom Page

Run from this directory:

```bash
docker cp \
  index.html \
  nginx-practice:/usr/share/nginx/html/index.html
```

Refresh:

```bash
curl http://localhost:8080
```

## Important Observation

The copied file is stored in the container’s writable layer.

If the container is removed and recreated, the modification will be lost:

```bash
docker rm -f nginx-practice
```

Recreate:

```bash
docker run -d \
  --name nginx-practice \
  -p 8080:80 \
  nginx:alpine
```

The original Nginx page will return.

Permanent application files should normally be included in a custom image or stored using an appropriate volume.

## View Logs

```bash
docker logs nginx-practice
docker logs -f nginx-practice
```

Open the page multiple times and observe new access-log entries.

Press `Ctrl+C` to stop following the logs.

## Monitor Resources

```bash
docker stats nginx-practice
```

Press `Ctrl+C` to return to the terminal.

## Cleanup

```bash
docker stop nginx-practice
docker rm nginx-practice
```
