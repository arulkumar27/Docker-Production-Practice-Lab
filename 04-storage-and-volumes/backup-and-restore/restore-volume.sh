#!/usr/bin/env sh

set -eu

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <destination-volume> <backup-file>"
  exit 1
fi

DESTINATION_VOLUME="$1"
BACKUP_PATH="$2"

if [ ! -f "$BACKUP_PATH" ]; then
  echo "Error: Backup file '$BACKUP_PATH' does not exist."
  exit 1
fi

if [ ! -s "$BACKUP_PATH" ]; then
  echo "Error: Backup file '$BACKUP_PATH' is empty."
  exit 1
fi

if ! docker volume inspect "$DESTINATION_VOLUME" >/dev/null 2>&1; then
  echo "Error: Destination volume '$DESTINATION_VOLUME' does not exist."
  echo "Create it with: docker volume create $DESTINATION_VOLUME"
  exit 1
fi

BACKUP_DIRECTORY="$(cd "$(dirname "$BACKUP_PATH")" && pwd)"
BACKUP_FILE="$(basename "$BACKUP_PATH")"

echo "Restoring backup into volume: $DESTINATION_VOLUME"
echo "Warning: Existing files in the destination volume will be replaced."

docker run --rm \
  --mount "type=volume,source=${DESTINATION_VOLUME},target=/destination" \
  --mount "type=bind,source=${BACKUP_DIRECTORY},target=/backup,readonly" \
  alpine:latest \
  sh -c "find /destination -mindepth 1 -delete && tar -xzf '/backup/${BACKUP_FILE}' -C /destination"

echo "Restore completed successfully."
