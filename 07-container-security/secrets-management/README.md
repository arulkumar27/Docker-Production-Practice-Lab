# Docker Secrets Management Practice

This exercise provides a database password to PostgreSQL through a mounted secret file.

## Important Limitation

With regular local Docker Compose, the secret is mounted from a local file. This is safer than embedding it inside the image or Compose environment section, but the source file must still be protected on the host.

For production, use an approved secret-management system.

## Create the Local Secret

Linux or macOS:

```bash
cp \
  secrets/database-password.txt.example \
  secrets/database-password.txt
```

Windows PowerShell:

```powershell
Copy-Item `
  secrets/database-password.txt.example `
  secrets/database-password.txt
```

Replace the example value with a strong local practice password.

## Protect File Permissions on Linux

```bash
chmod 600 secrets/database-password.txt
```

## Start the Database

```bash
docker compose up -d
```

## Check Health

```bash
docker compose ps
```

## Verify Secret Mount

```bash
docker compose exec database \
  ls -l /run/secrets
```

The secret is available inside the container at:

```text
/run/secrets/database_password
```

Avoid printing secret values in logs, screenshots or documentation.

## Connect to PostgreSQL

Open a shell:

```bash
docker compose exec database sh
```

Inside the container:

```sh
export PGPASSWORD="$(cat /run/secrets/database_password)"
psql -U secure_user -d secure_database
```

Exit PostgreSQL:

```text
\q
```

Exit the container:

```sh
exit
```

## Why `_FILE` Is Used

PostgreSQL supports:

```text
POSTGRES_PASSWORD_FILE
```

Instead of placing the password directly in:

```text
POSTGRES_PASSWORD
```

The container reads the password from the mounted file.

## Do Not Store Secrets in These Locations

Do not place real secrets in:

- Dockerfiles
- Git repositories
- Image labels
- Source code
- Public CI/CD logs
- Shell history
- Screenshots
- README files
- Public container registries

## Production Secret Systems

Examples include:

- AWS Secrets Manager
- AWS Systems Manager Parameter Store
- HashiCorp Vault
- CI/CD encrypted secret stores
- Kubernetes Secrets with appropriate encryption
- Docker Swarm secrets

## Cleanup

Remove the stack and database data:

```bash
docker compose down --volumes
```

The local secret file remains on the host. Keep it protected or remove it manually when it is no longer required.
