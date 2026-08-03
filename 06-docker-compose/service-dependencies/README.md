# Compose Service Dependencies

This exercise runs PostgreSQL and Adminer using Docker Compose.

Adminer starts only after PostgreSQL reports a healthy state.

## Architecture

```text
Browser
   |
Host port 8080
   |
Adminer
   |
Docker network
   |
PostgreSQL
   |
Named volume
```

## Important Security Note

The credentials in this folder are only for local practice.

Do not use these credentials in production and do not publish real credentials in Git repositories.

## Validate the Configuration

```bash
docker compose config
```

## Start the Stack

```bash
docker compose up -d
```

## Watch Container Status

```bash
docker compose ps
```

## View Database Logs

```bash
docker compose logs -f database
```

## Check Database Health

```bash
docker inspect \
  --format '{{.State.Health.Status}}' \
  dependencies-database
```

## Access Adminer

Open:

```text
http://localhost:8080
```

Use:

```text
System: PostgreSQL
Server: database
Username: practice_user
Password: practice_password
Database: practice_database
```

The server must be `database`, not `localhost`.

Inside the Adminer container, `localhost` refers to the Adminer container itself. Docker DNS resolves `database` to the PostgreSQL service.

## Query the Database from the Terminal

```bash
docker compose exec database \
  psql \
  -U practice_user \
  -d practice_database
```

Inside PostgreSQL:

```sql
SELECT * FROM practice_tasks;
```

Exit:

```text
\q
```

Run without opening an interactive session:

```bash
docker compose exec database \
  psql \
  -U practice_user \
  -d practice_database \
  -c "SELECT * FROM practice_tasks;"
```

## Understanding `depends_on`

```yaml
depends_on:
  database:
    condition: service_healthy
```

This makes Compose wait for the database health check before starting Adminer.

It does not guarantee that every future database request will succeed. Applications must still handle connection failures and retry appropriately.

## Initialization Behaviour

SQL files under:

```text
/docker-entrypoint-initdb.d
```

are executed only when PostgreSQL initializes an empty data directory.

If the named volume already contains database data, changing `01-init.sql` will not automatically rerun it.

For a completely fresh local practice database:

```bash
docker compose down --volumes
docker compose up -d
```

Warning: `--volumes` permanently deletes the existing practice database data.

## Test Persistence

Stop and remove containers without deleting volumes:

```bash
docker compose down
```

Start again:

```bash
docker compose up -d
```

Query:

```bash
docker compose exec database \
  psql \
  -U practice_user \
  -d practice_database \
  -c "SELECT * FROM practice_tasks;"
```

The data remains because PostgreSQL uses a named volume.

## Remove Containers and Network

```bash
docker compose down
```

## Remove Everything Including Database Data

```bash
docker compose down --volumes
```
