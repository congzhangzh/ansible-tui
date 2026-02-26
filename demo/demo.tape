# VHS Tape for Ansible TUI Demo
# Run with: vhs demo.tape

Output demo.gif

Set FontSize 16
Set Width 1200
Set Height 800
Set Padding 20
Set Theme "Dracula"

Type "../dist/ansible-tui -C inventory.yml playbook.yml"
Enter
Sleep 2s

# Navigate hosts
Down 1
Space
Down 2
Space
Sleep 1s

# Switch to Playbook
Tab
Sleep 1s
Down 1
Space
Down 1
Space
Sleep 1s

# Toggle commands
Type "c"
Sleep 500ms
Type "d"
Sleep 1s

# Run it
Type "r"
Sleep 4s

# Go back
Enter
Sleep 2s
Type "q"
