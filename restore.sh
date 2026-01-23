#!/usr/bin/env bash
# restore.sh
# Restores configuration from your dotfiles repository
# Run from inside your dotfiles folder: ./restore.sh
# WARNING: This script overwrites existing files!
#          Make backups first if you're unsure.

set -euo pipefail

DOTFILES="$PWD"
HOME_CONFIG="$HOME/.config"

echo "┌──────────────────────────────────────────────────────┐"
echo "│           Starting restoration of your setup         │"
echo "│             Press Ctrl+C at any time to stop         │"
echo "└──────────────────────────────────────────────────────┘"
echo ""

confirm() {
    read -p "$1 [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]]
}

# ──────────────────────────────────────────────────────────────────────────────
echo "1.  Shell & basic dotfiles"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore .bashrc, .gitconfig, .vimrc etc. ?"; then
    ln -sf "$DOTFILES/.bashrc"           ~/.bashrc           2>/dev/null || true
    ln -sf "$DOTFILES/.bash_profile"     ~/.bash_profile     2>/dev/null || true
    ln -sf "$DOTFILES/.gitconfig"        ~/.gitconfig        2>/dev/null || true
    ln -sf "$DOTFILES/vimrc"             ~/.vimrc            2>/dev/null || true
    ln -sfn "$DOTFILES/vim"              ~/.vim              2>/dev/null || true
    echo "→ Basic dotfiles linked"
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "2.  Firefox GNOME Theme (userChrome.css + related files)"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore Firefox GNOME Theme files?"; then
    PROFILE_DIR=$(find ~/.mozilla/firefox/ -maxdepth 1 -type d -name "*.default-release" -print -quit 2>/dev/null)
    if [[ -n "$PROFILE_DIR" ]]; then
        mkdir -p "$PROFILE_DIR/chrome"
        ln -sfn "$DOTFILES/firefox/chrome"/* "$PROFILE_DIR/chrome/" 2>/dev/null || true
        echo "→ Firefox theme files linked to $PROFILE_DIR/chrome"
    else
        echo "→ Could not find default Firefox profile. Skipping."
    fi
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "3.  GNOME settings (dconf) - shortcuts, extensions, themes, etc."
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore full GNOME settings from dconf dump? (VERY RECOMMENDED)"; then
    if [[ -f "$DOTFILES/dconf-settings.ini" || -f "$DOTFILES/backups/full-dconf-backup.ini" ]]; then
        FILE="${DOTFILES}/dconf-settings.ini"
        [[ -f "$DOTFILES/backups/full-dconf-backup.ini" ]] && FILE="$DOTFILES/backups/full-dconf-backup.ini"
        dconf load / < "$FILE"
        echo "→ Full dconf settings restored"
    else
        echo "→ No dconf dump file found. Skipping."
    fi
fi

if confirm "Restore GNOME extensions specific settings?"; then
    if [[ -f "$DOTFILES/extensions/gnome-extensions-full.dconf" ]]; then
        dconf load /org/gnome/shell/extensions/ < "$DOTFILES/extensions/gnome-extensions-full.dconf"
        echo "→ Extensions settings restored"
    fi
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "4.  GTK themes, icon themes, cursor themes"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore custom GTK/icon/cursor themes?"; then
    mkdir -p ~/.themes ~/.icons
    cp -r "$DOTFILES/themes/"* ~/.themes/  2>/dev/null || true
    cp -r "$DOTFILES/icons/"*  ~/.icons/   2>/dev/null || true
    echo "→ Themes & icons copied"
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "5.  LibreOffice full user profile"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore full LibreOffice configuration?"; then
    mkdir -p "$HOME_CONFIG/libreoffice"
    cp -r "$DOTFILES/libreoffice/"* "$HOME_CONFIG/libreoffice/" 2>/dev/null || true
    echo "→ LibreOffice profile restored"
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "6.  Remmina (connections & settings)"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore Remmina profiles & settings?"; then
    mkdir -p "$HOME_CONFIG/remmina" ~/.local/share/remmina
    cp -r "$DOTFILES/remmina/config/"* "$HOME_CONFIG/remmina/"     2>/dev/null || true
    cp -r "$DOTFILES/remmina/data/"*   ~/.local/share/remmina/     2>/dev/null || true
    echo "→ Remmina configuration restored"
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "7.  User-installed pip packages (global --user)"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Reinstall user pip packages?"; then
    if [[ -f "$DOTFILES/pip/user-pip-requirements.txt" ]]; then
        pip install --user -r "$DOTFILES/pip/user-pip-requirements.txt"
        echo "→ User pip packages reinstalled"
    else
        echo "→ No pip requirements file found"
    fi
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "8.  Flatpak applications list (reinstall)"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Reinstall Flatpak apps from list?"; then
    if [[ -f "$DOTFILES/backups/flatpak-installed.txt" ]]; then
        echo "The following apps will be installed:"
        cat "$DOTFILES/backups/flatpak-installed.txt"
        if confirm "Proceed with Flatpak reinstall?"; then
            while read -r line; do
                app=$(echo "$line" | awk '{print $1}')
                [[ -n "$app" ]] && flatpak install --user --noninteractive "$app" || true
            done < "$DOTFILES/backups/flatpak-installed.txt"
            echo "→ Flatpak reinstall finished"
        fi
    else
        echo "→ No flatpak list found"
    fi
fi

# ──────────────────────────────────────────────────────────────────────────────
echo "9.  Other useful files (mimeapps, pavucontrol, monitors...)"
# ──────────────────────────────────────────────────────────────────────────────

if confirm "Restore miscellaneous config files?"; then
    ln -sf "$DOTFILES/.config/mimeapps.list"     "$HOME_CONFIG/mimeapps.list"     2>/dev/null || true
    ln -sf "$DOTFILES/.config/pavucontrol.ini"   "$HOME_CONFIG/pavucontrol.ini"   2>/dev/null || true
    ln -sf "$DOTFILES/.config/monitors.xml"      "$HOME_CONFIG/monitors.xml"      2>/dev/null || true
    ln -sf "$DOTFILES/.config/user-dirs.dirs"    "$HOME_CONFIG/user-dirs.dirs"    2>/dev/null || true
    echo "→ Misc configs linked"
fi

echo ""
echo "┌──────────────────────────────────────────────────────┐"
echo "│                  Restoration finished!               │"
echo "│  → You should log out and log back in                │"
echo "│  → Or restart GNOME Shell: Alt+F2 → r → Enter        │"
echo "│  → Some changes (themes/extensions) need relogin     │"
echo "└──────────────────────────────────────────────────────┘"
