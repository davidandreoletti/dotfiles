# Upgrade Google Cloud SDK
if command_exists 'gcloud'; then
    gcloud components update 1>/dev/null 2>&1 # silent
fi
