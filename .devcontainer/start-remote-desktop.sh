#!/usr/bin/env bash
set -euo pipefail

mkdir -p "$HOME/.vnc"
if [[ ! -f "$HOME/.vnc/passwd" ]]; then
  echo "VNC password is missing; run .devcontainer/install-remote-desktop.sh first." >&2
  exit 1
fi

start_background() {
  local name="$1"
  shift
  if ! pgrep -f "$name" >/dev/null; then
    nohup "$@" </dev/null >/dev/null 2>&1 &
  fi
}

start_background '[X]vfb :1 ' Xvfb :1 -screen 0 1440x900x24 -nolisten tcp
for _ in {1..20}; do
  if [[ -S /tmp/.X11-unix/X1 ]]; then
    break
  fi
  sleep 0.25
done
if [[ ! -S /tmp/.X11-unix/X1 ]]; then
  echo "Xvfb failed to start on display :1." >&2
  exit 1
fi

start_background '[x]fce4-session' env DISPLAY=:1 dbus-run-session -- startxfce4
start_background '[x]11vnc.*-rfbport 5901' x11vnc \
  -display :1 \
  -rfbport 5901 \
  -localhost \
  -rfbauth "$HOME/.vnc/passwd" \
  -forever \
  -shared \
  -noxdamage
start_background '[w]ebsockify.*6080' websockify \
  --web=/usr/share/novnc \
  0.0.0.0:6080 \
  localhost:5901
