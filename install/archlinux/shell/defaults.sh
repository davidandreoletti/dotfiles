# Oamrchy OS variant
if command -v omarchy-version > /dev/null; then
   # Change boot logo
   #cp -v "./.medias/jolly-roger.png" "/usr/share/plymouth/themes/omarchy/logo.png"
   # Reflect boot logo changes
   sudo update-alternatives --config omarchy.plymouth
   sudo limine-update
fi
