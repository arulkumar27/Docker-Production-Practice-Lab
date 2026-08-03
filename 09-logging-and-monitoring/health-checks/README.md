# Docker Health-Check Practice

This exercise creates:

- One healthy Nginx container
- One intentionally unhealthy Alpine container

## Start the Services

```bash
docker compose up -d
```

## Check Status

```bash
docker compose ps
```

After the configured intervals, the status should show:

```text
healthy-web       healthy
unhealthy-demo    unhealthy
```

## Inspect Healthy Service

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  healthy-web
```

## Inspect Unhealthy Service

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  unhealthy-demo
```

## View Health-Check History

```bash
docker inspect \
  --format '{{json .State.Health}}' \
  unhealthy-demo
```

Formatted with `jq` when installed:

```bash
docker inspect \
  --format '{{json .State.Health}}' \
  unhealthy-demo |
  jq
```

## Test the Healthy Endpoint

```bash
curl http://localhost:8080
```

Run the health-check command manually:

```bash
docker exec healthy-web \
  wget --quiet --tries=1 --spider http://127.0.0.1:80/
```

Check its result:

```bash
echo $?
```

Exit code `0` means success.

## Understand the Configuration

```yaml
healthcheck:
  test:
    - CMD-SHELL
    - wget --quiet --tries=1 --spider http://127.0.0.1:80/ || exit 1
  interval: 10s
  timeout: 5s
  retries: 3
  start_period: 10s
```

| Setting | Purpose |
|---|---|
| `test` | Command used to test the service |
| `interval` | Time between checks |
| `timeout` | Maximum time allowed for one check |
| `retries` | Consecutive failures before unhealthy |
| `start_period` | Initial startup allowance |

## Running but Unhealthy

Check the unhealthy process:

```bash
docker top unhealthy-demo
```

The main process is still running.

The container is unhealthy because nothing responds on port `9999`.

This demonstrates:

```text
Process running ≠ Application healthy
```

## Health Checks and Restarts

Docker marks a container as unhealthy, but a normal standalone Docker health check does not automatically guarantee that the container will be restarted.

Restart behaviour depends on the runtime, orchestrator and surrounding automation.

## Good Health Endpoint Characteristics

A health endpoint should:

- Respond quickly
- Avoid expensive operations
- Return a clear success or failure
- Check important application readiness
- Avoid exposing sensitive information
- Use suitable timeouts

## Liveness vs Readiness

| Check | Question |
|---|---|
| Liveness | Is the application process functioning? |
| Readiness | Is the application ready to receive traffic? |

Docker provides one container health status. Platforms such as Kubernetes provide separate liveness and readiness probes.

## Troubleshooting an Unhealthy Container

1. Check status:

```bash
docker ps
```

2. View health history:

```bash
docker inspect unhealthy-demo
```

3. Run the health command manually.

4. Check application logs:

```bash
docker logs unhealthy-demo
```

5. Confirm the correct port.

6. Confirm the application listens on `0.0.0.0` when external container access is required.

7. Check required dependencies.

## Cleanup

```bash
docker compose down
```
