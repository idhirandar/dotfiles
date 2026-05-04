#!/usr/bin/env bash
# Simple Update Script for X1 Carbon (Fedora 44)

set -euo pipefail
cd "$(dirname "$0")"

echo "=== Updating dotfiles (x1carbon-fedora) ==="

# === Basic configs ===
cp -f ~/.bashrc          .bashrc          2>/dev/null || true
cp -f ~/.gitconfig       .gitconfig       2>/dev/null || true
cp -f ~/.vimrc           vimrc            2>/dev/null || true

# === Most Important: GNOME Settings ===
dconf dump / > dconf-settings.ini

# Extensions
mkdir -p extensions
dconf dump /org/gnome/shell/extensions/ > extensions/gnome-extensions-full.dconf

# === Current Active Themes (Clean way) ===
mkdir -p backups
echo "Current Themes:" 
gsettings get org.gnome.desktop.interface gtk-theme     | tee backups/current-gtk-theme.txt
gsettings get org.gnome.desktop.interface icon-theme    | tee backups/current-icon-theme.txt
gsettings get org.gnome.desktop.interface cursor-theme  | tee backups/current-cursor-theme.txt

# Firefox
mkdir -p firefox/chrome
PROFILE=$(find ~/.mozilla/firefox/ -maxdepth 1 -name "*.default-release" -print -quit)
if [[ -n "$PROFILE" && -d "$PROFILE/chrome" ]]; then
    cp -rf "$PROFILE/chrome/"* firefox/chrome/ 2>/dev/null || true
fi

# Misc configs
mkdir -p .config
cp -f ~/.config/mimeapps.list     .config/ 2>/dev/null || true
cp -f ~/.config/monitors.xml      .config/ 2>/dev/null || true

echo "✅ Changes captured successfully!"

git add .bashrc .gitconfig vimrc dconf-settings.ini extensions/ firefox/ backups/ .config/ 2>/dev/null || true
git add -u

git status --short

read -p "Commit message (e.g. Update after changing theme): " msg
[[ -z "$msg" ]] && msg="Update $(date +%Y-%m-%d)"

git commit -m "$msg"
git push origin x1carbon-fedora

echo "✅ Pushed to GitHub!"
