FROM_DIR="$PWD/dotfiles-private3s"
TO_DIR="$PWD/dotfiles-private3d"

git -C "$FROM_DIR" rev-list --reverse master | while read -r sha
do
    echo ">>>>> $sha"
    cd "$FROM_DIR" || exit 5
        git clean -f -d && git clean -f -d -X && git checkout master && git reset --hard HEAD && git checkout "$sha" && git status || exit 1
    cd "$TO_DIR" || exit 4
        rsync -avz --recursive \
            --exclude '.git' \
            --exclude '.git-crypt' \
            --exclude '.gitattributes' \
            --exclude 'README2.rst' \
            --delete \
            "$FROM_DIR/" "$TO_DIR/" && \
        git add . && \
        git commit -m "$(git show -s --format='%B' $sha)" && \
        git -C "$FROM" ls-files | xargs -L1 -I % bash -c "echo \"\$(sha256sum %)\" | sha256sum --check --status || exit 255" || \
            exit 2
done

