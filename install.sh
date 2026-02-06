#!/usr/bin/env bash

set -e

backup_file() {
    if [[ -f "$1" ]]; then
        cp "$1" "$1.bak"
    fi
}

for cmd in greetd hyprland quickshell; do
    if ! command -v "$cmd" $> /dev/null; then
        echo "Warning: $cmd not found in PATH"
    fi
done

if [[ $EUID -ne 0 ]]; then
    echo "Please run as root (sudo ./install.sh)"
    exit 1
fi

echo "Installing Hyprland login config..."
backup_file /etc/hypr/login.conf
install -Dm644 ./etc/hypr/login.conf /etc/hypr/login.conf

echo "Installing Quickshell greeter UI..."
backup_file /etc/quickshell/login.qml
install -Dm644 ./etc/quickshell/login.qml /etc/quickshell/login.qml

echo "Installing greetd config..."
backup_file /etc/greetd/config.toml
install -Dm644 ./etc/greetd/config.toml /etc/greetd/config.toml

echo "Everything installed successfully."
echo
echo "To finish setup:"
echo " systemctl enable --now greetd.service"
echo " systemctl enable --now seatd.service"