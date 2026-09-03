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

[ -z "$file" ] && exit 0

# This pane is herdr's popup: a session-modal singleton, not a real tiled
# pane (no pane ID, no persistence, no agent APIs). Editing here would mean
# a real editing session lives somewhere herdr never treats as a proper
# pane. Open a real split pane instead and hand the file off to it, then
# let this script exit so the popup closes.
herdr_bin="${HERDR_BIN_PATH:-herdr}"
target_pane="$("$herdr_bin" pane split --direction right --cwd "$target_cwd" --focus | jq -r '.result.pane.pane_id // empty')"
[ -z "$target_pane" ] && { echo "open-editor: couldn't open a pane for $file" >&2; exit 1; }

# intentionally unquoted: editor may be "code --wait" etc, needs word-splitting
"$herdr_bin" pane run "$target_pane" $editor "$file"
