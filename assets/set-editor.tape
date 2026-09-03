# Generates assets/set-editor.png — the editor-selection popup.
#
#   vhs assets/set-editor.tape
#
# Same requirements/notes as pick.tape.

Output assets/set-editor.png

Set Shell "bash"
Set FontSize 14
Set Width 1200
Set Height 400
Set Padding 0

Type "herdr"
Enter
Sleep 2s

Ctrl+B
Ctrl+U
Sleep 1s

Screenshot assets/set-editor.png

Ctrl+C
