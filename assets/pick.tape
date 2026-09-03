# Generates assets/pick.png — the file-picker popup.
# Run from inside the herdr-open-editor repo (or any git repo with a few
# files) so the fzf list has real content to show.
#
#   vhs assets/pick.tape
#
# Requires: vhs (https://github.com/charmbracelet/vhs), ttyd, ffmpeg.
# Captures whatever herdr theme/colors are active in *your* config —
# run it in your real terminal, not a stripped-down/CI shell, so the
# screenshot matches what you actually see day to day.

Output assets/pick.png

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 700
Set Padding 0

Type "herdr"
Enter
Sleep 3s

Ctrl+B
Sleep 300ms
Ctrl+E
Sleep 2s

Screenshot assets/pick.png

Ctrl+C
