# Docker Compose Environment Variables

This exercise uses environment variables to configure a PostgreSQL and Adminer stack.

## Why Environment Variables Are Used

Environment variables make configuration adjustable without editing the Compose file.

Common examples include:

- Image versions
- Application environment
- Database names
- Usernames
- Service ports
- Logging levels
- Health-check intervals

## Create the Local Environment File

Linux or macOS:

```bash
cp .env.example .env
```

Windows PowerShell:

```powershell
Copy-Item .env.example .env
```

Update the local practice password inside `.env`.

Do not commit `.env`.

## Validate Variable Resolution

```bash
docker compose config
```

This command shows the resolved configuration.

Be careful: resolved output can display sensitive environment values.

## Start the Stack

```bash
docker compose up -d
```

## Check Services

```bash
docker compose ps
```

## Access Adminer

Open:

```text
http://localhost:8080
```

Use the values configured in `.env`.

The database server name is:

```text
database
```

## Variable Syntax

### Required Value

```yaml
POSTGRES_DB: ${POSTGRES_DB:?POSTGRES_DB must be provided}
```

Compose reports an error if the variable is missing.

### Default Value

```yaml
image: postgres:${POSTGRES_IMAGE_TAG:-17-alpine}
```

If `POSTGRES_IMAGE_TAG` is missing, Compose uses `17-alpine`.

### Escaped Runtime Variable

```yaml
pg_isready -U $${POSTGRES_USER}
```

Double dollar signs prevent Compose from replacing the variable on the host. The variable is expanded inside the container.

## Override a Variable Temporarily

Linux or macOS:

```bash
ADMINER_HOST_PORT=8081 docker compose up -d
```

Windows PowerShell:

```powershell
$env:ADMINER_HOST_PORT="8081"
docker compose up -d
Remove-Item Env:ADMINER_HOST_PORT
```

## Environment Variable Security

An `.env` file is convenient for local practice, but it is not a complete production secret-management solution.

Production environments should use approved systems such as:

- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- HashiCorp Vault
- Kubernetes Secrets with suitable encryption and access control
- CI/CD secret stores

Never commit:

- Passwords
- API keys
- Private keys
- Access tokens
- Cloud credentials

## Stop the Stack

```bash
docker compose down
```

## Remove Database Data

```bash
docker compose down --volumes
```

This permanently deletes the Compose-managed database volume.
