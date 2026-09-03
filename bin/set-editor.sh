#!/usr/bin/env bash
set -euo pipefail
export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:${PATH:-}"
source "$(dirname "$0")/lib.sh"

current="$(load_editor)"

# binary -> launch command (GUI editors need a flag that blocks until closed)
declare -A candidates=(
  [nvim]=nvim [vim]=vim [vi]=vi [nano]=nano [micro]=micro
  [emacs]="emacs -nw" [hx]=hx [kak]=kak [joe]=joe [ne]=ne
  [code]="code --wait" [subl]="subl --wait" [zed]="zed --wait" [zeditor]="zeditor --wait"
)

found=()
for bin in "${!candidates[@]}"; do
  command -v "$bin" >/dev/null 2>&1 && found+=("${candidates[$bin]}")
done
list="$(printf '%s\n' "${found[@]}" | sort)"

# --print-query: Enter on a typed name with no match still returns it, so an
# editor not in the detected list can still be set by hand.
set +e
output="$(printf '%s\n' "$list" | fzf --print-query \
  --prompt="editor (current: $current)> " \
  --header='Esc cancels, Enter picks the highlighted line or the typed text')"
status=$?
set -e
[ $status -ne 0 ] && exit 0   # Esc / ctrl-c: leave editor unchanged

mapfile -t lines <<< "$output"
choice="${lines[1]:-${lines[0]:-}}"

if [ -n "$choice" ]; then
  mkdir -p "$(dirname "$CONFIG_FILE")"
  printf 'OPEN_EDITOR=%q\n' "$choice" > "$CONFIG_FILE"
fi
