# Docker Minecraft SkyFactory 5

A Docker image for running a Minecraft SkyFactory 5 modded server.

## Features

- Based on `openjdk:27-ea-jdk-slim-bookworm`
- Automatically downloads and installs the SkyFactory 5 modpack (configurable)
- Persistent world data via Docker volumes
- Configurable JVM memory, MOTD, level name, and operators
- GitHub Actions workflow for building and pushing to GHCR

## Quick Start

### Local Build & Run

```bash
./run.sh
```

This script will:
1. Build the Docker image (with `SKIP_DOWNLOAD=true` by default for faster local builds)
2. Stop/remove any existing container with the same name
3. Start a new container with persistent data volume

### Manual Docker Commands

```bash
# Build the image
docker build -t minecraft-skyfactory5 .

# Run the container
docker run -d \
  -p 25565:25565 \
  --name mc-skyfactory5 \
  -v mc-skyfactory5-data:/data \
  minecraft-skyfactory5
```

## Configuration

### Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `MINECRAFT_MOD_VERSION` | `5.0.8` | SkyFactory version |
| `MINECRAFT_MOD_NAME` | `SkyFactory-5` | Modpack name |
| `MINECRAFT_MOD_PACKAGE` | *(CurseForge URL)* | Full URL to server ZIP |
| `MINECRAFT_MEMORY` | `4096m` | JVM heap size |
| `SKIP_DOWNLOAD` | `false` | Skip downloading modpack (for local builds) |

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `MOTD` | `A Minecraft (SkyFactory-5 5.0.8) Server Powered by Docker` | Server message of the day |
| `LEVEL` | `world` | World/level name |
| `OPS` | *(empty)* | Comma-separated list of operator usernames |
| `JVM_OPTS` | `-Xms4096m -Xmx4096m` | JVM options |

### Example with Custom Settings

```bash
docker run -d \
  -p 25565:25565 \
  --name mc-skyfactory5 \
  -v mc-skyfactory5-data:/data \
  -e MOTD="My SkyFactory Server" \
  -e LEVEL="myworld" \
  -e OPS="player1,player2" \
  -e JVM_OPTS="-Xms8192m -Xmx8192m" \
  minecraft-skyfactory5
```

## GitHub Actions CI/CD

The repository includes a GitHub Actions workflow to build and push the image to GitHub Container Registry (GHCR).

### Trigger the Workflow

1. Go to **Actions** → **Build and push to GHCR**
2. Click **Run workflow**
3. Fill in the inputs:
   - `mod_version`: Modpack version (e.g., `5.0.8`)
   - `mod_name`: Modpack name (e.g., `SkyFactory-5`)
   - `mod_package_url`: Full URL to the server ZIP
   - `skip_download`: Set to `false` to include the modpack in the image
   - `image_name`: *(optional)* Custom image name

### Workflow Inputs

| Input | Required | Default | Description |
|-------|----------|---------|-------------|
| `mod_version` | Yes | `5.0.8` | Modpack version for tagging |
| `mod_name` | Yes | `SkyFactory-5` | Modpack name |
| `mod_package_url` | Yes | *(CurseForge URL)* | Server ZIP download URL |
| `skip_download` | No | `true` | Skip download during build |
| `image_name` | No | *(auto)* | Custom `owner/repo` for image name |

### Pull the Image

After a successful workflow run:

```bash
docker pull ghcr.io/<your-username>/skyfactory-5:5.0.8
```

## File Structure

```
.
├── Dockerfile          # Container image definition
├── run.sh              # Local build & run helper script
├── start.sh            # Container entrypoint script
├── README.md           # This file
└── .github/
    └── workflows/
        └── build-and-push.yml  # CI/CD workflow
```

## Volumes

The container uses `/data` as the working directory for world data and server files. Mount a volume to persist data:

```bash
-v mc-skyfactory5-data:/data
```

## Ports

| Port | Description |
|------|-------------|
| `25565` | Minecraft server port |

## Notes

- **SKIP_DOWNLOAD**: When `true`, the Docker build skips downloading the modpack ZIP. This is useful for faster local builds when you already have the modpack files or want to mount them separately.
- **EULA**: The server automatically accepts the Minecraft EULA (`eula=true`).
- **Memory**: Default is 4GB. Adjust `MINECRAFT_MEMORY` build arg or `JVM_OPTS` env var for your needs.

## License

MIT
