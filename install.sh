#!/usr/bin/env bash
#
# install.sh - installs notifier + systemd --user unit for autostart on Linux Mint
#
set -euo pipefail

BIN_DIR="${HOME}/.local/bin"
SYSTEMD_USER_DIR="${HOME}/.config/systemd/user"

echo "==> Checking dependencies..."
if ! command -v notify-send >/dev/null 2>&1; then
    echo "notify-send not found. Installing libnotify-bin..."
    sudo apt-get update -y
    sudo apt-get install -y libnotify-bin
fi

echo "==> Installing notifier to ${BIN_DIR}"
if [[ ! -e ${BIN_DIR} ]]; then
    mkdir -p "${BIN_DIR}"
fi
cp "$(dirname "$0")/notifier" "${BIN_DIR}/notifier"
chmod +x "${BIN_DIR}/notifier"

echo "==> Installing systemd --user service"
if [[ ! -e ${SYSTEMD_USER_DIR} ]]; then
    mkdir -p "${SYSTEMD_USER_DIR}"
fi 
cp "$(dirname "$0")/notifier.service" "${SYSTEMD_USER_DIR}/notifier.service"

echo "==> Reloading systemd user daemon"
systemctl --user daemon-reload

echo "==> Enabling notifier to start on login"
systemctl --user enable notifier.service

# Ensure user services keep running across boot even without an active login shell (optional)
if command -v loginctl >/dev/null 2>&1; then
    sudo loginctl enable-linger "${USER}" || true
fi

echo
echo "Installation complete."
echo
echo "Add ${BIN_DIR} to your PATH if it's not already (it usually is on Mint by default)."
echo
echo "Usage:"
echo "  notifier start [json-file]"
echo "  notifier exit"
echo "  notifier status"
echo
echo "Note: the systemd service runs the loop directly with whatever was last saved"
echo "to ~/.config/notifier/notifier.conf. Run 'notifier start ...' once manually"
echo "first to set your desired title/message/interval, then it will persist across reboots."
echo
echo "To autostart via systemd immediately (without rebooting):"
echo "  systemctl --user start notifier.service"
echo "To stop the systemd-managed instance:"
echo "  systemctl --user stop notifier.service"
