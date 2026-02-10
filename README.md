<p align="center">
  <img src="https://cdn.cloudflare.steamstatic.com/steam/apps/550/header.jpg" alt="Left 4 Dead 2" width="460">
</p>

<h1 align="center">🐣 L4D2 Pterodactyl Eggs</h1>

<p align="center">
  <strong>Optimized Docker images for running a Left 4 Dead 2 dedicated server on Pterodactyl</strong>
</p>

<p align="center">
  <a href="https://github.com/vstyler96/eggs/actions"><img src="https://img.shields.io/github/actions/workflow/status/vstyler96/eggs/docker-publish.yml?style=flat-square&label=build" alt="Build Status"></a>
  <a href="https://github.com/vstyler96/eggs/blob/main/LICENSE"><img src="https://img.shields.io/github/license/vstyler96/eggs?style=flat-square&color=blue" alt="License"></a>
  <a href="https://ghcr.io/vstyler96/l4d2-bookworm"><img src="https://img.shields.io/badge/GHCR-bookworm-blue?style=flat-square&logo=docker" alt="Bookworm Image"></a>
  <a href="https://ghcr.io/vstyler96/l4d2-trixie"><img src="https://img.shields.io/badge/GHCR-trixie-blue?style=flat-square&logo=docker" alt="Trixie Image"></a>
</p>

---

## Overview

Lightweight, production-ready Docker images for hosting a **Left 4 Dead 2** dedicated server (`app_id: 222860`), purpose-built for [Pterodactyl](https://pterodactyl.io). Ships with SteamCMD and [RCON CLI](https://github.com/gorcon/rcon-cli) pre-installed.

### Available Images

| Image | Base | Tag |
|-------|------|-----|
| **Bookworm** | `debian:bookworm-slim` | `ghcr.io/vstyler96/l4d2-bookworm:latest` |
| **Trixie** | `debian:trixie-slim` | `ghcr.io/vstyler96/l4d2-trixie:latest` |

---

## Features

- **Minimal footprint** — built on Debian Slim with `--no-install-recommends`
- **Multi-arch support** — `TARGETOS` / `TARGETARCH` build args
- **SteamCMD ready** — 32-bit and 64-bit SDK libraries pre-configured
- **RCON included** — remote console management out of the box
- **Proper signal handling** — runs under [tini](https://github.com/krallin/tini) with `SIGINT` stop signal
- **Steam Guard compatible** — supports authenticated Steam accounts

---

## Environment Variables

> Since Valve removed Left 4 Dead 2 from the anonymous SteamCMD depot, a Steam account is required to download the server files.

| Variable | Default | Description |
|----------|---------|-------------|
| `STEAM_USER` | `anonymous` | Steam account username |
| `STEAM_PASSWORD` | *(empty)* | Steam account password |

---

## Pterodactyl Setup

### 1. Create the Egg

Navigate to **Admin Panel > Nests > Source Engine** and create a new egg called **Left 4 Dead 2**.

### 2. Docker Image

Add one (or both) of the available images:

```
Bookworm|ghcr.io/vstyler96/l4d2-bookworm:latest
Trixie|ghcr.io/vstyler96/l4d2-trixie:latest
```

### 3. Startup Command

```
./srcds_run -strictportbind -norestart -port {{SERVER_PORT}}
```

### 4. Start Configuration

```json
{
    "done": "Connection to Steam servers successful.",
    "userInteraction": []
}
```

### 5. Stop Command

```
^C
```

### 6. Configuration Files

```json
{}
```

### 7. Log Configuration

```json
{
    "custom": true,
    "location": "logs/latest.log"
}
```

### 8. Install Script

```bash
#!/bin/bash
set -e

./Steam/steamcmd.sh \
    +force_install_dir /mnt/server \
    +login $STEAM_USER $STEAM_PASSWORD \
    +app_update 222860 validate \
    +quit
```

---

## License

This project is licensed under the [GNU Affero General Public License v3.0](LICENSE).
