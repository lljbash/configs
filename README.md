# Configs

My linux cli workspace configurations (e.g. dot files, useful snippets, color schemes, etc.).

## Bootstrap

If you want a one-step-setup to reproduce my current workspace, there is a bootstrap procedure.

### Prerequisite

- `make` (or `just`)
- `conda` properly initialized for your current shell

### Setup

```bash
make bootstrap
```

This would automatically configure `zsh`, `nvim` and `tmux`, as well as install some binaries via `conda` (see `app.yaml`).

You may need to setup the login shell yourself if it was not `zsh`.

NOTE: This procedure may mess up your current environment. Please refer to `justfile` for more information.
