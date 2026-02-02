# repomix-git-hook

A `pre-push` git hook that packs the repository into a single `repomix.xml` file and publishes it as a secret GitHub gist.

## What it does

On every `git push`:

1. Runs `repomix` to produce `repomix.xml` (a single-file representation of the repo).
2. Creates a **secret** GitHub gist named after the repository, or updates the existing one.
3. Writes the gist URL to `repomix.url`. If that file is new or the URL changed, it commits and pushes the update automatically.
4. Removes the local `repomix.xml` after upload.

## Prerequisites

- [repomix](https://github.com/yamadashy/repomix) (`npm i -g repomix`)
- [GitHub CLI](https://cli.github.com/) (`gh`), authenticated via `gh auth login`
- Node.js (required by repomix)

## Install

```sh
git clone <this-repo> && cd repomix-git-hook
./install.sh /path/to/your/repo
```

`install.sh` copies `pre-push` into the target repo's `.git/hooks/` and adds `repomix.xml` to its `.gitignore`. Run without arguments to install in the current directory.

## Files

| File | Tracked | Purpose |
|------|---------|---------|
| `repomix.xml` | no (gitignored) | Temporary build artifact, deleted after upload |
| `repomix.url` | yes | Persists the gist URL so subsequent pushes update the same gist |

## Notes

- The hook exits cleanly (exit 0) if any dependency is missing, so it never blocks a push.
- Bash and zsh compatible (`#!/usr/bin/env bash`).
- A `REPOMIX_PUSHING` environment variable guards against infinite recursion when the hook pushes the `repomix.url` commit.
