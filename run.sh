#!/usr/bin/env bash
set -euo pipefail

# Configurable names (can be overridden in environment)
IMAGE_NAME=${IMAGE_NAME:-minecraft-skyfactory5}
CONTAINER_NAME=${CONTAINER_NAME:-mc-skyfactory5}
VOLUME_NAME=${VOLUME_NAME:-mc-skyfactory5-data}
HOST_PORT=${HOST_PORT:-25565}
CONTAINER_PORT=${CONTAINER_PORT:-25565}

SKIP_DOWNLOAD_ARG=${SKIP_DOWNLOAD_ARG:-true}
echo "[run.sh] Building Docker image: $IMAGE_NAME (SKIP_DOWNLOAD=${SKIP_DOWNLOAD_ARG})"
docker build --build-arg SKIP_DOWNLOAD=${SKIP_DOWNLOAD_ARG} -t "$IMAGE_NAME" .

# If a container with the same name exists, stop and remove it to avoid conflicts
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
	echo "[run.sh] Found existing container '$CONTAINER_NAME' - stopping and removing it"
	docker rm -f "$CONTAINER_NAME"
fi

echo "[run.sh] Starting container: $CONTAINER_NAME"
docker run -d -p ${HOST_PORT}:${CONTAINER_PORT} --name "$CONTAINER_NAME" -v ${VOLUME_NAME}:/data "$IMAGE_NAME"

echo "[run.sh] Done. Container '$CONTAINER_NAME' should be running (check with: docker ps)."