# herdr-open-editor

Fuzzy-pick a file with [fzf](https://github.com/junegunn/fzf) and open it in
your own `$EDITOR` — vim, nvim, nano, emacs, or a GUI editor with a `--wait`
flag (`code --wait`, `subl --wait`, `zed --wait`).

## Install

```sh
herdr plugin install jimididit/herdr-open-editor
# or, for a local checkout: herdr plugin link /path/to/herdr-open-editor
```

Bind the two actions in `~/.config/herdr/config.toml` (herdr binds none by
default):

```toml
[[keys.command]]
key = "prefix+ctrl+e"
type = "shell"
command = "herdr plugin action invoke pick --plugin jdi.open-editor"

[[keys.command]]
key = "prefix+ctrl+u"
type = "shell"
command = "herdr plugin action invoke set-editor --plugin jdi.open-editor"
```

## Usage

- **Pick a file:** opens a popup, fuzzy-searches every git-tracked file (or,
  outside a git repo, everything in the pane's cwd minus dotfiles), then
  `exec`s your editor over it. `?` toggles the fzf preview panel. `esc`
  cancels.
- **Set editor:** opens a popup listing every editor it finds installed
  (checks `nvim`, `vim`, `vi`, `nano`, `micro`, `emacs`, `hx`, `kak`, `joe`,
  `ne`, `code`, `subl`, `zed`, `zeditor`). Pick one, or type a name that
  isn't in the list and hit enter to use it anyway. `esc` cancels without
  changing anything.

Editor precedence: whatever `set-editor` last saved > `$EDITOR` > `vi`.
Stored in `~/.config/herdr/plugins/config/jdi.open-editor/config.env`.

## Requirements

`fzf`, `jq`, herdr ≥ 0.7.4, Linux/macOS.
