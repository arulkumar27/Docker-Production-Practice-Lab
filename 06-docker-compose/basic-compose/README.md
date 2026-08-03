# Basic Docker Compose Practice

This exercise runs an Nginx web server using Docker Compose.

## Validate the Configuration

Run from the `basic-compose` directory:

```bash
docker compose config
```

This displays the resolved configuration and reports YAML or Compose errors.

## Start the Application

```bash
docker compose up -d
```

## Check the Service

```bash
docker compose ps
```

## Test the Website

```bash
curl http://localhost:8080
```

Browser:

```text
http://localhost:8080
```

## View Logs

```bash
docker compose logs web
```

Follow logs:

```bash
docker compose logs -f web
```

Press `Ctrl+C` to stop following logs. The container will continue running.

## Check Health

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  basic-compose-web
```

Expected after the startup period:

```text
healthy
```

## Execute a Command

```bash
docker compose exec web nginx -v
```

Open a shell:

```bash
docker compose exec web /bin/sh
```

Exit:

```bash
exit
```

## Test Bind-Mount Updates

Modify:

```text
html/index.html
```

Refresh the browser. The update appears without rebuilding the image.

## Stop Services

```bash
docker compose stop
```

## Start Stopped Services

```bash
docker compose start
```

## Restart the Web Service

```bash
docker compose restart web
```

## Remove the Stack

```bash
docker compose down
```

This removes the container and Compose network. The local HTML files remain.
