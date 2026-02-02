#!/usr/bin/env bash
# Install the repomix pre-push hook into a git repository.
# Usage: ./install.sh [-f|--force] [/path/to/repo]  (defaults to current directory)

set -e

FORCE=0
TARGET=""

for arg in "$@"; do
  case "$arg" in
    -f|--force) FORCE=1 ;;
    *) TARGET="$arg" ;;
  esac
done

TARGET="${TARGET:-.}"
TARGET="$(cd "$TARGET" && git rev-parse --show-toplevel 2>/dev/null)" || {
  echo "Error: '${TARGET}' is not inside a git repository." >&2
  exit 1
}

HOOK_SRC="$(cd "$(dirname "$0")" && pwd)/pre-push"
HOOK_DST="$TARGET/.git/hooks/pre-push"

if [ -f "$HOOK_DST" ] && [ "$FORCE" -eq 0 ]; then
  echo "A pre-push hook already exists at $HOOK_DST"
  printf 'Overwrite? [y/N] '
  read -r ans
  case "$ans" in [yY]*) ;; *) echo "Aborted."; exit 1 ;; esac
fi

cp "$HOOK_SRC" "$HOOK_DST"
chmod +x "$HOOK_DST"
echo "Installed pre-push hook to $HOOK_DST"

# Ensure repomix.xml is git-ignored in the target repo
GITIGNORE="$TARGET/.gitignore"
if ! grep -qxF 'repomix.xml' "$GITIGNORE" 2>/dev/null; then
  printf 'repomix.xml\n' >> "$GITIGNORE"
  echo "Added repomix.xml to $GITIGNORE"
fi
