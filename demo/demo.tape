# VHS Tape for Ansible TUI Demo
# Run with: vhs demo.tape
# Prerequisite: ansible-tui binary must be in PATH (install with install.sh)

Output demo.gif

Set FontSize 14
Set Width 1200
Set Height 700
Set Padding 20
Set Theme "Dracula"
Set PlaybackSpeed 0.75

# Launch with clean state
Type "../dist/ansible-tui -C inventory.yml playbook.yml"
Enter
Sleep 2s

# Select first host group (webservers — all hosts)
Space
Sleep 500ms

# Move down and select db01
Down 2
Space
Sleep 1s

# Switch to Playbook panel
Tab
Sleep 800ms

# Expand the first play
Enter
Sleep 500ms

# Navigate and select some tasks
Down 2
Space
Sleep 400ms
Down 1
Space
Sleep 800ms

# Toggle --check (dry-run)
Type "c"
Sleep 500ms

# Toggle --diff
Type "d"
Sleep 1s

# Show expand-all feature
Type "e"
Sleep 800ms
Type "e"
Sleep 500ms

# Run it
Type "r"
Sleep 5s

# Scroll output
Down 3
Sleep 1s

# Go back to selection
Enter
Sleep 1500ms

# Quit
Type "q"
