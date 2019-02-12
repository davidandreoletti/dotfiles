PER_USER_CHROME_EXTENSIONS_DIR_PATH="$HOME/Library/Application Support/Google/Chrome/External Extensions/"
mkdir -pv "$PER_USER_CHROME_EXTENSIONS_DIR_PATH"

for f in $(find . -type f -name "*.json");
do
    echo "Installing $f to $PER_USER_CHROME_EXTENSIONS_DIR_PATH"
    cp -v "$f" "$PER_USER_CHROME_EXTENSIONS_DIR_PATH/"
done
