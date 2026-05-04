#!/usr/bin/env bash
# update-big.sh - For major updates (Fedora upgrade, many changes)

set -euo pipefail

DOTFILES="$PWD"
BACKUP_DIR="$DOTFILES/backups/$(date +%Y-%m-%d_%H-%M)"

echo "┌──────────────────────────────────────────────────────┐"
echo "│     Big Update - x1carbon-fedora (Fedora 44)         │"
echo "└──────────────────────────────────────────────────────┘"
echo ""

if [[ $(git branch --show-current) != "x1carbon-fedora" ]]; then
    echo "❌ Not on x1carbon-fedora branch!"
    exit 1
fi

confirm() { read -p "$1 [y/N] " -n 1 -r; echo; [[ $REPLY =~ ^[Yy]$ ]]; }

mkdir -p "$BACKUP_DIR"

echo "=== Capturing current system state ==="

# 1. Basic dotfiles
cp -f ~/.bashrc          "$DOTFILES/.bashrc"          2>/dev/null || true
cp -f ~/.bash_profile    "$DOTFILES/.bash_profile"    2>/dev/null || true
cp -f ~/.gitconfig       "$DOTFILES/.gitconfig"       2>/dev/null || true
cp -f ~/.vimrc           "$DOTFILES/vimrc"            2>/dev/null || true
echo "→ Basic dotfiles updated"

# 2. GNOME Settings (Very Important after upgrade)
dconf dump / > "$DOTFILES/dconf-settings.ini"
echo "→ Full GNOME settings (dconf) updated"

mkdir -p "$DOTFILES/extensions"
dconf dump /org/gnome/shell/extensions/ > "$DOTFILES/extensions/gnome-extensions-full.dconf"
echo "→ GNOME Extensions settings updated"

# 3. Themes & Icons (You changed them)
mkdir -p "$DOTFILES/themes" "$DOTFILES/icons"
rsync -a --delete ~/.themes/ "$DOTFILES/themes/" 2>/dev/null || true
rsync -a --delete ~/.icons/  "$DOTFILES/icons/"  2>/dev/null || true
echo "→ Themes & Icons updated"

# 4. Firefox
PROFILE_DIR=$(find ~/.mozilla/firefox/ -maxdepth 1 -type d -name "*.default-release" -print -quit 2>/dev/null)
if [[ -n "$PROFILE_DIR" && -d "$PROFILE_DIR/chrome" ]]; then
    mkdir -p "$DOTFILES/firefox/chrome"
    cp -rf "$PROFILE_DIR/chrome/"* "$DOTFILES/firefox/chrome/" 2>/dev/null || true
    echo "→ Firefox theme updated"
fi

# 5. Other configs
mkdir -p "$DOTFILES/.config"
cp -f "$HOME/.config/mimeapps.list"    "$DOTFILES/.config/" 2>/dev/null || true
cp -f "$HOME/.config/monitors.xml"     "$DOTFILES/.config/" 2>/dev/null || true
cp -f "$HOME/.config/pavucontrol.ini"  "$DOTFILES/.config/" 2>/dev/null || true

# 6. Package lists
mkdir -p "$DOTFILES/backups" "$DOTFILES/pip"
flatpak list --app --columns=application > "$DOTFILES/backups/flatpak-installed.txt"
pip freeze --user > "$DOTFILES/pip/user-pip-requirements.txt" 2>/dev/null || true
echo "→ Package lists updated"

echo ""
echo "All major changes captured!"

# Git
git add .

echo ""
git status --short

read -p "Enter commit message: " msg
[[ -z "$msg" ]] && msg="Big update: Fedora 43 → 44 + new extensions + themes + configs - $(date +%Y-%m-%d)"

git commit -m "$msg"
git push origin x1carbon-fedora

echo ""
echo "✅ Successfully pushed to GitHub (x1carbon-fedora branch)"
