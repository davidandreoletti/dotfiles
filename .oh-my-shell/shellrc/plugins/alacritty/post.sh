ALACRITTY_THEMES_DIR="$HOME/.config/alacritty/themes"

# Clone or update themes
git -C "$ALACRITTY_THEMES_DIR" pull > /dev/null \
    || git clone https://github.com/alacritty/alacritty-theme "$ALACRITTY_THEMES_DIR" > /dev/null
