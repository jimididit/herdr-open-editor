#!/usr/bin/env bash
# herdr runs plugin commands with a minimal PATH.
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"

# Editor precedence: plugin config file > $EDITOR > vi.
# ponytail: no GUI-editor / --wait detection, add if a GUI $EDITOR shows up
source "$(dirname "$0")/lib.sh"
editor="$(load_editor)"

# plugin commands run with the plugin dir as cwd; the real pane/workspace
# cwd only comes through the context JSON.
ctx_json="${HERDR_PLUGIN_CONTEXT_JSON:-}"
[ -z "$ctx_json" ] && ctx_json='{}'
target_cwd="$(printf '%s' "$ctx_json" | jq -r '.focused_pane_cwd // .workspace_cwd // empty' 2>/dev/null || true)"
cd "${target_cwd:-$HOME}"

file="$(git ls-files --cached --others --exclude-standard 2>/dev/null \
  || find . -type f -not -path '*/.*/*' -not -name '.*')"
# fzf exits nonzero on Esc/no-match; that's a normal cancel, not a script error
file="$(printf '%s\n' "$file" | fzf --prompt="open> " \
  --preview 'bat --color=always {} 2>/dev/null || cat {}' \
  --bind '?:toggle-preview')" || exit 0

# intentionally unquoted: editor may be "code --wait" etc, needs word-splitting
[ -n "$file" ] && exec $editor "$file"
