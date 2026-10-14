#!/usr/bin/env bash
# Upload every skill in .claude/skills to the Claude API (Skills API) so it can be
# used from the Messages API, Agent SDK and Managed Agents.
# Usage: ANTHROPIC_API_KEY=sk-ant-... scripts/upload-skills-to-api.sh [skill-name ...]
set -euo pipefail

: "${ANTHROPIC_API_KEY:?Set ANTHROPIC_API_KEY}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT/.claude/skills"

if [ "$#" -gt 0 ]; then names=("$@"); else
  names=(); for d in */; do names+=("${d%/}"); done
fi

for name in "${names[@]}"; do
  args=()
  while IFS= read -r f; do args+=(-F "files[]=@$f;filename=$f"); done < <(find "$name" -type f | sort)
  echo "Uploading $name..."
  curl -sS --fail-with-body https://api.anthropic.com/v1/skills \
    -H "x-api-key: $ANTHROPIC_API_KEY" \
    -H "anthropic-version: 2023-06-01" \
    -H "anthropic-beta: skills-2025-10-02" \
    -F "display_title=$name" \
    "${args[@]}"
  echo
done
