# Usage:
# echo "salut" | translate_email.sh

# Read from stdio
email="$(cat -)"

# Assume plain text email
content="$email"

# Convert from HTML email to Markdown
if grep -qi "<html" <<< "$email"; then
    content="$(echo "$email" | pandoc --strip-comments --from=html --to=gfm-raw_html+pipe_tables+autolink_bare_uris)"
fi

# Translate
echo "$content" | trans --show-original n -b -no-autocorrect
