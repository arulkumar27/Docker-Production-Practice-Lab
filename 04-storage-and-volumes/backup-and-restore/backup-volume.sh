#!/usr/bin/env sh

set -eu

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <volume-name>"
  exit 1
fi

VOLUME_NAME="$1"
BACKUP_DIRECTORY="$(pwd)/backups"
BACKUP_FILE="${VOLUME_NAME}-backup.tar.gz"

if ! docker volume inspect "$VOLUME_NAME" >/dev/null 2>&1; then
  echo "Error: Docker volume '$VOLUME_NAME' does not exist."
  exit 1
fi

mkdir -p "$BACKUP_DIRECTORY"

echo "Creating backup for volume: $VOLUME_NAME"

docker run --rm \
  --mount "type=volume,source=${VOLUME_NAME},target=/source,readonly" \
  --mount "type=bind,source=${BACKUP_DIRECTORY},target=/backup" \
  alpine:latest \
  tar -czf "/backup/${BACKUP_FILE}" -C /source .

if [ ! -s "${BACKUP_DIRECTORY}/${BACKUP_FILE}" ]; then
  echo "Error: Backup file was not created correctly."
  exit 1
fi

echo "Backup created successfully:"
echo "${BACKUP_DIRECTORY}/${BACKUP_FILE}"
