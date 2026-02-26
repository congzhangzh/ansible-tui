# Ansible TUI Runner

A terminal UI for selecting hosts, tasks and tags from your Ansible inventory and playbook, then running `ansible-playbook` with the chosen options — all without leaving the TUI.

## Quick Start

```bash
cd ansible/tui
npm install
npx tsx app.tsx
```

## Usage

```bash
# Auto-discover inventory.yml and playbook.yml from CWD or parent dir
npx tsx app.tsx

# Explicit paths (positional args)
npx tsx app.tsx /path/to/inventory.yml /path/to/playbook.yml

# Clean start — ignore saved state
npx tsx app.tsx --clean
npx tsx app.tsx -C
```

### Deno

```bash
# Local (auto-resolves deps via deno.json import map)
deno run --allow-read --allow-run --allow-write --allow-env app.tsx

# Remote (pass import map explicitly)
deno run --allow-read --allow-run --allow-write --allow-env \
  --import-map=https://raw.githubusercontent.com/<user>/<repo>/main/ansible/tui/deno.json \
  https://raw.githubusercontent.com/<user>/<repo>/main/ansible/tui/app.tsx
```

## Keybindings

### Selection

| Key | Action |
|---|---|
| `Tab` | Switch between Hosts / Playbook panel |
| `↑` `↓` | Navigate |
| `Space` | Toggle checkbox (play toggles all children) |
| `→` / `Enter` | Expand play |
| `←` | Collapse play (on task: jump to parent) |
| `a` | Select / deselect all hosts |

### Flags & Actions

| Key | Action |
|---|---|
| `c` | Toggle `--check` flag (dry-run mode) |
| `d` | Toggle `--diff` flag (show changes) |
| `r` | Run `ansible-playbook` with current flags |
| `s` | Show command (print to terminal and exit) |
| `q` | Quit |

Flags are shown as indicators below the command preview (`check:ON/off`, `diff:ON/off`) and are included in the generated command automatically.

### Output Viewer (running / done)

| Key | Action |
|---|---|
| `↑` `↓` | Scroll output |
| `Enter` | Back to selection (done phase) |
| `q` | Cancel (running) / Quit (done) |

## How It Works

1. **Parse** — Reads `inventory.yml` for host groups and `playbook.yml` for plays/tasks (recursively expanding `block:` structures)
2. **Select** — Interactive TUI for choosing hosts, tasks, and flags (`--check`, `--diff`)
3. **Run** — Executes `ansible-playbook` as a child process with output streamed inside the TUI (colored via `ANSIBLE_FORCE_COLOR`)
4. **Iterate** — After execution, press `Enter` to return to selection with all choices preserved. Adjust and run again without restarting

### Tag Logic

- Tags with `never` are filtered from display
- Selecting tasks automatically collects their effective tags into `--tags`
- If a play is gated by `[never, X]`, selecting any task under it adds `X` to `--tags`

## State Persistence

Selection state (hosts, tasks, expanded plays, check/diff flags) is saved to `.ansible-tui-state.json` alongside your inventory file. On next launch, the previous selections are restored automatically.

Use `--clean` or `-C` to start fresh and ignore the saved state.

## File Discovery

When no positional args are given, the tool looks for `inventory.yml` and `playbook.yml` in:

1. Current working directory
2. Parent directory (`..`)

This means it works from both `ansible/` and `ansible/tui/`.

## Future: Pure Deno

The current setup supports both Node (via `tsx`) and Deno (via `deno.json` import map). A future version may switch to `npm:` specifiers directly in the source:

```typescript
import React from "npm:react@18";
import { render } from "npm:ink@5";
import { load } from "npm:js-yaml@4";
```

This would enable true zero-install remote execution:

```bash
deno run -A https://raw.githubusercontent.com/.../app.tsx
```

No `deno.json`, no `npm install`, no `node_modules`. Just one URL.
