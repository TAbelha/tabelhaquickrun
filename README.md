<div align="center">

# Tabela Quick Run

**English** · [Português](README.pt-BR.md)

[![License: AGPL-3.0](https://img.shields.io/badge/license-AGPL--3.0-blue?style=flat-square)](LICENSE)

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/ianptkcs)

</div>

---

A [DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell) launcher
plugin that runs a shell command from the launcher/spotlight — but, unlike a
generic "run command" box, it matches against **your actual fish functions and
abbreviations** as you type, and always executes through a login
[fish](https://fishshell.com/) shell (`fish -lc`), so your functions,
abbreviations, and `PATH` setup work exactly like they do in a real terminal.

## Why not just use a generic command runner?

Plugins like [Command Runner](https://github.com/devnullvoid/dms-command-runner)
suggest commands via bash's `compgen -c`, which only sees executables on
`$PATH` — it has no idea your fish functions (`hrwiv`, `gacp`, whatever you've
defined in `~/.config/fish/functions/`) exist, and it runs the final command
with `sh -c`, which can't call fish functions/abbreviations at all. Quick Run
is built the other way around: it asks fish itself (`functions -n`,
`abbr --show`) what's available, and always hands the final command back to
`fish -lc`.

## Features

- Type a single word and get live-matched suggestions from your fish
  functions and abbreviations (exact match → prefix match → substring match),
  each showing where the function is defined or what the abbreviation expands
  to.
- The literal command you typed is always the top suggestion, so arbitrary
  one-off shell commands (`htop`, `git status`, …) work with no setup.
- Once you type a space (you're into arguments), suggestions get out of the
  way and only the literal command remains — so `hrwiv --ai opencode` runs
  exactly as typed.
- Matching data is fetched once in the background when the plugin loads, not
  on every keystroke.
- Configurable trigger character and suggestion count.

## Requirements

- DankMaterialShell `>=1.4.0`
- [fish shell](https://fishshell.com/) installed and on `PATH`

## Installation

```bash
git clone https://github.com/TabelaDev/tabelaquickrun.git \
    ~/.config/DankMaterialShell/plugins/quickRun
dms ipc call plugin-scan scan
dms ipc call plugins enable quickRun
```

Then bind a key to open the launcher pre-filled with the trigger, e.g. in
niri:

```kdl
Mod+Semicolon { spawn "dms" "ipc" "call" "spotlight" "openQuery" ";"; }
```

## Configuration

Open **Settings → Plugins → Quick Run** in DankMaterialShell:

- **Trigger** — the prefix that activates Quick Run in the launcher (default `;`).
- **Max suggestions** — how many matching functions/abbreviations to show
  below the literal command (default `8`).

## How it works

On load, the plugin runs two one-shot commands through a login fish shell and
caches the results:

- `functions -n` (plus `functions -D <name>` per function) — every loaded
  fish function and where it's defined.
- `abbr --show` — every abbreviation and its expansion.

Typing a single word filters that cache; selecting a suggestion or pressing
enter on the literal command runs `fish -lc "<command>"` via
`Quickshell.execDetached`.

## License

[AGPL-3.0](LICENSE)
