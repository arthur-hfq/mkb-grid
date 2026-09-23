# mkb-grid

> **Bespoke Terminal UI & Infrastructure Control Node for Local Docker Services**

```
╔══════════════════════════════════════════════════════════════╗
║  [MKB-GRID] INFRASTRUCTURE CONTROL NODE                      ║
╠══════════════════════════════════════════════════════════════╣
║  SERVICES DASHBOARD                                          ║
║  Total Nodes: 4 | Running: 3 | Paused: 1                     ║
║                                                              ║
║  ▸ mkb_svc_postgres_5432       Up 4 hours      5432->5432    ║
║    mkb_svc_redis_6379          Up 4 hours      6379->6379    ║
║    mkb_svc_kafka_9092          Up 2 hours      9092->9092    ║
║    mkb_svc_rabbitmq_5672       Exited (0)      5672->5672    ║
║                                                              ║
╚══════════════════════════════════════════════════════════════╝
```

`mkb-grid` is a zero-dependency, keyboard-driven terminal dashboard designed to orchestrate local development infrastructure. It replaces verbose `docker run` commands and bloated web UIs with an ultra-responsive, brutalist terminal interface featuring automatic port collision resolution, Btrfs subvolume snapshotting, network topology management, and instant Docker Compose exports.

---

## ⚡ Key Features

- **Interactive TUI Dashboard**: Real-time service states, health status, port bindings, and container IDs navigated with vim/arrow keys.
- **Preconfigured Service Catalog**:
  - **PostgreSQL 16** (`postgres:16-alpine`)
  - **MySQL 8.4** (`mysql:8.4`)
  - **MongoDB 7** (`mongo:7`)
  - **Redis 7** (`redis:7-alpine`)
  - **Apache Kafka 3.7** (KRaft mode without Zookeeper, `apache/kafka:3.7.0`)
  - **RabbitMQ 3** with Management UI (`rabbitmq:3-management-alpine`)
  - **Custom Image**: Any arbitrary OCI image with customizable internal/external ports and runtime flags.
- **Automated Free Port Discovery**: Scans host TCP sockets via `ss` and Docker mappings to automatically assign the next available collision-free port.
- **Btrfs Subvolume Snapshots**:
  - Leverages Btrfs copy-on-write subvolumes for persistent database storage.
  - Create atomic point-in-time snapshots of database state.
  - Instantly rollback databases to clean states without recreating containers.
- **Topology & Network Isolation**:
  - Create, tag, and inspect custom bridge networks (`mkb_net_*`).
  - Hot-attach and detach running containers between networks.
  - **Panorama View**: Stream aggregated live logs across all containers attached to a specific network.
- **Resource Constraints**: Easily assign CPU limits (`--cpus`) and memory quotas (`--memory`) during provisioning or inspection.
- **Docker Compose Synchronization**: Generates a clean, production-ready `mkb-grid-compose.yml` reflecting the current grid state.

---

## 📦 Requirements

- **Linux** (Tested on Arch Linux, kernel >= 6.x)
- **Docker** (`docker engine` running and accessible by your current user)
- **Bash** (version 4.0 or newer)
- **iproute2** (`ss` command for active port detection)
- **ncurses** (`tput` for terminal formatting)
- *Optional:* **btrfs-progs** (for subvolume snapshotting and zero-copy rollbacks)

---

## 🚀 Installation

### Automated Install

Clone this repository and run the installer:

```bash
git clone https://github.com/<your-username>/mkb-grid.git
cd mkb-grid
chmod +x install.sh
./install.sh
```

The script copies the executable to `~/.local/bin/mkb-grid` and initializes the local data directory at `~/.local/share/mkb-grid`.

Make sure `~/.local/bin` is in your `$PATH`:

```bash
# Add to ~/.bashrc or ~/.zshrc:
export PATH="$HOME/.local/bin:$PATH"
```

### Manual Install

```bash
cp bin/mkb-grid ~/.local/bin/mkb-grid
chmod +x ~/.local/bin/mkb-grid
mkdir -p ~/.local/share/mkb-grid/volumes
touch ~/.local/share/mkb-grid/tags.env
```

---

## 🖥️ Usage

Launch `mkb-grid` from any terminal:

```bash
mkb-grid
```

### Main Navigation

| Key | Action |
| :--- | :--- |
| `↑` / `k` | Navigate cursor up |
| `↓` / `j` | Navigate cursor down |
| `ENTER` | Select / Execute option |
| `ESC` / `q` | Back to previous screen / Exit |

### Core Menus

1. **Services Dashboard**
   - View running and stopped `mkb_svc_*` containers.
   - Press `ENTER` on any service to open its **Service Control Panel**.
2. **Deploy New Service**
   - Select a database or message broker from the menu.
   - Enter desired port (auto-detects free ports), root credentials, project tag, and CPU/RAM limits.
3. **Networks & Topology**
   - Create and tag custom Docker networks (`mkb_net_*`).
   - Attach or detach running services from networks.
   - View **Panorama Logs** to stream unified logs for all containers in a network.
4. **Volumes & Snapshots (Btrfs)**
   - Inspect subvolumes located in `~/.local/share/mkb-grid/volumes/`.
   - Take atomic snapshots (`mkb_vol_<service>_snap_<timestamp>`).
   - Roll back data to an earlier snapshot state.
5. **Export to Docker Compose**
   - Generates `mkb-grid-compose.yml` in the current working directory.
6. **Prune / Reset Grid**
   - Clean up stopped containers, dangling networks, or unmounted volumes with confirmation safeguards.

---

## 🗂️ File System Layout

```
~/.local/
├── bin/
│   └── mkb-grid                 # Executable script
└── share/
    └── mkb-grid/
        ├── tags.env             # Service and network metadata tags
        └── volumes/             # Btrfs subvolumes for database persistence
            ├── mkb_vol_postgres_5432_data/
            └── mkb_vol_redis_6379_data/
```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
