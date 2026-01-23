# dotfiles.
CONFIGRIGATION FILE FROM MULTIPLES PROGRAMS THAT I USED ON MY LINUX DESKTOP 
---------------------------------------------------------------------------

# My Dotfiles – ThinkPad X1 Carbon (Fedora)

Personal configuration files for Fedora Workstation on Lenovo ThinkPad X1 Carbon.

**Current setup**: Fedora 43, GNOME, Vim + vim-plug, Firefox GNOME theme, custom GTK/icons/themes, LibreOffice profile, Remmina connections, user pip packages, Flatpak list, GNOME extensions settings.

## Quick Setup on a New Machine

1. Clone the repo
   ```bash
   git clone https://github.com/idhirandar/dotfiles.git ~/.dotfiles
   cd ~/.dotfiles
   ```

2. (Optional) Switch to the main branch if not default
    ```bash
    git checkout x1carbon-Fedora
    ```

3. Backup your current ~/.config (just in case)
    ```bash
    tar -czf ~/config-backup-$(date +%Y-%m-%d).tar.gz ~/.CONFIGRIGATION
    ```

4. Run the restore script
    ```bash
    chmod +x restore.sh
    ./restore.sh
    ```


