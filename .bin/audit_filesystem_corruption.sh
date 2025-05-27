# Usage: audit_filesystem_corruption.sh /
# src: https://github.com/jessek/hashdeep
DIR="${1:-$HOME}"
FILE="/tmp/$$.auditfile"

echo "Audit file: $FILE"
# Generate the audit file
time hashdeep -c sha256 -o fl -r "$DIR" >"$FILE"
# Test the audit
time hashdeep -c sha256 -o fl -a -v -v -k "$FILE" -r "$DIR"
