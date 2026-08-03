# Docker Compose Profiles

Compose profiles allow optional services to be started only when required.

In this exercise:

| Service | Profile | Behaviour |
|---|---|---|
| `database` | None | Starts normally |
| `adminer` | `tools` | Starts only with the tools profile |
| `debug` | `debug` | Starts only with the debug profile |

## Validate the Configuration

```bash
docker compose config
```

## Start Default Services

```bash
docker compose up -d
```

Only the database starts.

Check:

```bash
docker compose ps
```

## Start the Tools Profile

```bash
docker compose --profile tools up -d
```

This starts:

- Database
- Adminer

Open Adminer:

```text
http://localhost:8080
```

Credentials:

```text
System: PostgreSQL
Server: database
Username: profile_user
Password: profile_password
Database: profile_database
```

These credentials are only for isolated local practice.

## Start the Debug Profile

```bash
docker compose --profile debug up -d
```

Check:

```bash
docker compose ps
```

Open the debugging container:

```bash
docker compose exec debug bash
```

Inside the container, test database DNS:

```bash
dig database
```

Test the database port:

```bash
nc -vz database 5432
```

View the route table:

```bash
ip route
```

Exit:

```bash
exit
```

## Start Multiple Profiles

```bash
docker compose \
  --profile tools \
  --profile debug \
  up -d
```

This starts all three services.

## Start a Specific Profile Service

```bash
docker compose run --rm debug
```

Because the configured command is `sleep infinity`, use an interactive override for one-time troubleshooting:

```bash
docker compose run --rm debug bash
```

## View Active Services

```bash
docker compose ps
```

## Why Profiles Are Useful

Profiles can keep optional services out of the normal application startup.

Examples:

- Database administration tools
- Debugging utilities
- Local mail testing
- Development-only services
- Optional monitoring components
- Data migration utilities

## Production Consideration

Debugging and administration services should not be exposed publicly without strong authentication, authorization and network restrictions.

Profiles control startup behaviour, but they do not independently provide security.

## Stop the Stack

To stop all services, including profiled services:

```bash
docker compose \
  --profile tools \
  --profile debug \
  down
```

## Remove Persistent Database Data

```bash
docker compose \
  --profile tools \
  --profile debug \
  down --volumes
```

The `--volumes` option permanently deletes the practice database data.
