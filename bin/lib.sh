# shellcheck shell=bash
# Shared by pick.sh and set-editor.sh: config file location + loader.
CONFIG_FILE="${HERDR_PLUGIN_CONFIG_DIR:-$HOME/.config/herdr/plugins/config/jdi.open-editor}/config.env"

load_editor() {
  [ -f "$CONFIG_FILE" ] && source "$CONFIG_FILE"
  printf '%s' "${OPEN_EDITOR:-${EDITOR:-vi}}"
}
