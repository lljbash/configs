# Configs

My linux cli workspace configurations (e.g. dot files, useful snippets, color schemes, etc.).

## Bootstrap

If you want a one-step-setup to reproduce my current workspace, there is a bootstrap procedure.

NOTE: This procedure may mess up your current environment. Please refer to `justfile` for more information.

### Prerequisite

- `make` (or `just`)
- `conda` properly initialized for your current shell

### Setup

```bash
make bootstrap
```

This would automatically configure `zsh`, `nvim` and `tmux`, as well as install some binaries via `conda` (see `app.yaml`).

You may need to setup the login shell yourself if it was not `zsh`.

The locations of auto-installed binaries (including `zsh`, `nvim` and `tmux`) are not in `$PATH` by default. If you wish to use them in another shell (e.g. `bash`), please refer to the first line of `zshenv`.

If you wish to change the login shell to the auto-installed `zsh` but don't have the permission to modify `/etc/shells`, considering use this trick:
```bash
# At the end of ~/.bash_profile
# Be careful, this is kinda dangerous
exec ~/.conda/env/app/bin/zsh
```
