#!/usr/bin/env bash
# Pull the latest mattpocock/skills and refresh every install target in this repo:
#   .claude/skills/<name>/   -> Claude Code (CLI, desktop, web, IDE) in this repo
#   dist/claude-ai/<name>.zip -> upload to claude.ai / Claude Desktop / mobile
# Usage: scripts/sync-skills.sh [git-ref]   (default: main)
set -euo pipefail

REF="${1:-main}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --quiet --depth 1 --branch "$REF" https://github.com/mattpocock/skills "$TMP/upstream"
SHA="$(git -C "$TMP/upstream" rev-parse HEAD)"

# Only the skills the upstream plugin ships (skips in-progress/misc/deprecated).
mapfile -t SKILLS < <(python3 -I -c 'import json,sys; print("\n".join(json.load(open(sys.argv[1]))["skills"]))' \
  "$TMP/upstream/.claude-plugin/plugin.json")

rm -rf "$ROOT/.claude/skills" "$ROOT/dist/claude-ai"
mkdir -p "$ROOT/.claude/skills" "$ROOT/dist/claude-ai"

for rel in "${SKILLS[@]}"; do
  name="$(basename "$rel")"
  cp -R "$TMP/upstream/$rel" "$ROOT/.claude/skills/$name"
  # claude.ai expects the skill folder at the zip root.
  (cd "$ROOT/.claude/skills" && zip -qrX "$ROOT/dist/claude-ai/$name.zip" "$name")
done

cp "$TMP/upstream/LICENSE" "$ROOT/.claude/skills/LICENSE-mattpocock-skills"
echo "$SHA" > "$ROOT/.claude/skills/UPSTREAM_COMMIT"
echo "Synced ${#SKILLS[@]} skills from mattpocock/skills@$SHA"
