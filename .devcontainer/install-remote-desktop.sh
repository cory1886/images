#!/usr/bin/env bash
set -euo pipefail

sudo apt-get update
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
  dbus-x11 \
  novnc \
  openssl \
  websockify \
  x11vnc \
  xfce4 \
  xfce4-terminal \
  xvfb

mkdir -p "$HOME/.vnc"
chmod 700 "$HOME/.vnc"

if [[ ! -f "$HOME/.vnc/passwd" ]]; then
  password="${REMOTE_DESKTOP_PASSWORD:-$(openssl rand -hex 4)}"
  if (( ${#password} < 8 )); then
    echo "REMOTE_DESKTOP_PASSWORD must be at least 8 characters." >&2
    exit 1
  fi
  x11vnc -storepasswd "$password" "$HOME/.vnc/passwd" >/dev/null
  chmod 600 "$HOME/.vnc/passwd"
  if [[ -z "${REMOTE_DESKTOP_PASSWORD:-}" ]]; then
    printf 'Remote desktop VNC password: %s\n' "$password"
  fi
fi
