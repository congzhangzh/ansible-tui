# Ansible TUI

> A beautiful terminal UI for running Ansible playbooks — without memorizing a
> single flag.

<div align="center">
  <img src="demo/demo.gif" alt="Ansible TUI Demo" width="800" />
</div>

<div align="center">

[![GitHub Release](https://img.shields.io/github/v/release/congzhangzh/ansible-tui?style=flat-square)](https://github.com/congzhangzh/ansible-tui/releases/latest)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue?style=flat-square)](LICENSE)
[![Deno Compatible](https://img.shields.io/badge/deno-compatible-brightgreen?style=flat-square&logo=deno)](https://deno.com)

</div>

---

## Install
### Download and install

```bash
curl -sL https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/install.sh | bash
./ansible-tui
```

No Node.js. No Python runtime. No background services. Just one binary.

### Run directly with Deno

```
deno run --allow-read --allow-run --allow-write --allow-env --import-map https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/deno.json https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/app.tsx
```

### Run with Deno (reload for latest deps)

```
deno run -R --allow-read --allow-run --allow-write --allow-env --import-map https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/deno.json https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/app.tsx
```
---

## The problem

Running `ansible-playbook` precisely is harder than it looks:

```bash
# Which tags were in that play again?
ansible-playbook -i inventory.yml site.yml \
  --limit "web01,web02" \
  --tags "deploy,restart" \
  --check --diff
```

You end up grepping YAML files, copy-pasting hostnames, and manually composing
`--tags` lists — every time.

Heavy orchestrators like **AWX** or **Semaphore** solve this at the cost of a
Kubernetes cluster, a PostgreSQL database, and a background daemon.

**Ansible TUI** is the middle ground: a zero-dependency, single-file executable
that gives you a visual interactive selector right in your terminal.

---

## What it looks like

```
┌──────────────────────────────────────────────────────────────────────────┐
│  🚀 Ansible TUI Runner                             ✓ Last run succeeded  │
│                                                                          │
│ ┌──── Hosts (2/3) ─────┐  ┌──── Playbook (4/7 tasks) ─────────────────┐ │
│ │ ❯ [x] webservers(2/2)│  │ ❯ ▼ [x] Deploy Application               │ │
│ │   [x]   web01        │  │     ▼ [~] Install packages  [apt]         │ │
│ │   [x]   web02        │  │       ❯ [x]   Install nginx               │ │
│ │   [ ] dbservers (0/1)│  │         [x]   Install certbot             │ │
│ │   [ ]   db01         │  │     ▼ [x] Deploy code  [deploy]           │ │
│ └──────────────────────┘  │       [x]   Sync files                    │ │
│                           │       [x]   Restart services               │ │
│ ┌─ Command Preview ──────────────────────────────────────────────────┐  │
│ │ ansible-playbook -i inventory.yml playbook.yml --limit web01,web02 │  │
│ │ --tags apt,deploy          --check ON   --diff off                 │  │
│ └────────────────────────────────────────────────────────────────────┘  │
│ [Tab] Switch  [Space] Toggle  [a] All Hosts  [e] Expand All  [r] Run    │
└──────────────────────────────────────────────────────────────────────────┘
```

---

## Why not just use…

|                             | Ansible TUI   | AWX / Semaphore   | `ansible-playbook` CLI |
| --------------------------- | ------------- | ----------------- | ---------------------- |
| **Setup**                   | Single binary | K8s + DB required | ✓ Already there        |
| **Visual host/task picker** | ✓             | ✓                 | ✗                      |
| **Live output streaming**   | ✓             | ✓                 | ✓                      |
| **State saved across runs** | ✓             | ✓                 | ✗                      |
| **Works offline / in SSH**  | ✓             | ✗                 | ✓                      |
| **Zero dependencies**       | ✓             | ✗                 | ✓                      |
| **Tag-aware selection**     | ✓             | Partial           | Manual                 |

---

## Usage

```bash
# Auto-discover inventory.yml and playbook.yml from CWD or parent dir
ansible-tui

# Explicit paths
ansible-tui /path/to/inventory.yml /path/to/playbook.yml

# Clean start — ignore saved state
ansible-tui --clean
ansible-tui -C

# Show version
ansible-tui --version
```

**Auto-discovery** checks both `.` and `..` for:

- Inventory: `inventory.yml`, `inventory.yaml`, `hosts.yml`, `hosts.yaml`,
  `hosts`
- Playbook: `playbook.yml`, `playbook.yaml`, `site.yml`, `site.yaml`

### Run without installing (Deno)

```bash
# One line, run from anywhere (no clone)
deno run --allow-read --allow-run --allow-write --allow-env --import-map https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/deno.json https://raw.githubusercontent.com/congzhangzh/ansible-tui/main/app.tsx
```

From a local clone (uses local `deno.json`):

```bash
deno run --allow-read --allow-run --allow-write --allow-env app.tsx
```

---

## Keyboard reference

### Navigation & Selection

| Key           | Action                                            |
| ------------- | ------------------------------------------------- |
| `Tab`         | Switch between Hosts / Playbook panel             |
| `↑` `↓`       | Move cursor                                       |
| `PgUp` `PgDn` | Page up / down                                    |
| `Space`       | Toggle checkbox (play/block toggles all children) |
| `→` / `Enter` | Expand play or block                              |
| `←`           | Collapse (on task/block: jump to parent)          |
| `a`           | Select / deselect all hosts                       |
| `e`           | Expand all / collapse all plays & blocks          |

### Flags & Actions

| Key | Action                                        |
| --- | --------------------------------------------- |
| `c` | Toggle `--check` (dry-run)                    |
| `d` | Toggle `--diff` (show changes)                |
| `r` | Run `ansible-playbook`                        |
| `s` | Print command and exit (for piping/scripting) |
| `q` | Quit                                          |

### Output viewer

| Key                     | Action            |
| ----------------------- | ----------------- |
| `↑` `↓` / `PgUp` `PgDn` | Scroll            |
| `Enter`                 | Back to selection |
| `q`                     | Quit              |

---

## How it works

1. **Parse** — Reads `inventory.yml` for host groups and `playbook.yml` for
   plays/tasks (recursively expands `block:` structures, respects inherited
   tags)
2. **Select** — Interactive split-pane TUI: left pane for host targeting
   (`--limit`), right pane for task/tag selection (`--tags`)
3. **Run** — Spawns `ansible-playbook` as a child process; output streams live
   inside the TUI with ANSI color support
4. **Iterate** — Press `Enter` after a run to return to selection with all
   choices intact. Tweak and re-run instantly.

### Tag logic

- Items tagged `never` are shown with a `(never)` indicator and their tag is
  never added to `--tags` automatically
- If a play itself has `[never, some-tag]`, selecting any task in that play will
  include `some-tag` in `--tags`
- Tags are rendered in **cyan** for quick identification

### State persistence

Selections (hosts, tasks, expanded plays, `--check`/`--diff` flags) are saved to
`.ansible-tui-state.json` next to your inventory. Restored automatically on next
launch. Use `--clean` to start fresh.

---

## Building from source

**Deno (recommended):**

```bash
git clone https://github.com/congzhangzh/ansible-tui
cd ansible-tui
deno compile --allow-read --allow-run --allow-write --allow-env -o ansible-tui app.tsx
```

**Node.js / tsx:**

```bash
npm install
npm start  # runs via tsx
```

---

## Contributing

Issues and PRs welcome. This is intentionally a **single-file** app — all logic
lives in `app.tsx` to keep it easy to audit, fork, and run without a build step.
