#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  [MKB-GRID] INSTALLER                                            ║
# ╚══════════════════════════════════════════════════════════════════╝

set -euo pipefail

BOLD=$(tput bold 2>/dev/null || true)
GREEN=$(tput setaf 2 2>/dev/null || true)
YELLOW=$(tput setaf 3 2>/dev/null || true)
RED=$(tput setaf 1 2>/dev/null || true)
RESET=$(tput sgr0 2>/dev/null || true)

echo "${BOLD}==> Installing mkb-grid...${RESET}"

# Check Docker dependency
if ! command -v docker &> /dev/null; then
    echo "${YELLOW}[WARNING] Docker is not installed or not in PATH.${RESET}"
    echo "mkb-grid requires Docker to manage containers and networks."
fi

# Define destination directory
TARGET_DIR="${HOME}/.local/bin"
mkdir -p "$TARGET_DIR"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_BIN="${SCRIPT_DIR}/bin/mkb-grid"

if [ ! -f "$SOURCE_BIN" ]; then
    echo "${RED}[ERROR] Binary source not found at: ${SOURCE_BIN}${RESET}"
    exit 1
fi

chmod +x "$SOURCE_BIN"

# Copy binary to destination
cp "$SOURCE_BIN" "${TARGET_DIR}/mkb-grid"
chmod +x "${TARGET_DIR}/mkb-grid"

# Prepare data directories
DATA_DIR="${HOME}/.local/share/mkb-grid"
mkdir -p "${DATA_DIR}/volumes"
touch "${DATA_DIR}/tags.env"

echo "${GREEN}[OK] Installed successfully to ${TARGET_DIR}/mkb-grid${RESET}"

# Verify PATH
if [[ ":$PATH:" != *":${TARGET_DIR}:"* ]]; then
    echo "${YELLOW}[NOTE] Make sure ${TARGET_DIR} is in your PATH:${RESET}"
    echo "       export PATH=\"\$HOME/.local/bin:\$PATH\" (add to ~/.bashrc or ~/.zshrc)"
fi

echo ""
echo "Run ${BOLD}mkb-grid${RESET} in your terminal to start."
