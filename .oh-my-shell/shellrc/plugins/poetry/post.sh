# Install poetry when missing only
pipx list --short | grep -q poetry \
    || pipx install poetry
