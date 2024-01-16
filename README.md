# Configs

My linux cli workspace configurations (e.g. dot files, useful snippets, color schemes, etc.).

## Bootstrap

If you want a one-step-setup to reproduce my current workspace, there is a bootstrap procedure.

NOTE: This procedure may mess up your current environment. Please refer to `justfile` for more information.

### Prerequisites

- `make` (or `just`)
- `conda` properly initialized for your current shell

### Fonts

You have to use a [Nerd Font](https://www.nerdfonts.com/) patched font to correctly show the icons.

I am using [FiraCodeNF](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip) for normal text and [SourceCodeProNF](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/SourceCodePro.zip) for italic text.

If your terminal (e.g. Windows Terminal) does not allow seperated font settings for normal and italic text, consider use [fira-code-italic-fallback](https://github.com/lljbash/fira-code-italic-fallback), which is called FiraCodeNF-MediumItalic but is actually slightly-tweaked SourceCodeProNF-MediumItalic.

### Setup

```bash
make bootstrap
```

This would automatically configure `zsh`, `nvim` and `tmux`, as well as install some binaries via `conda` (see `app.yaml`).

`zsh`, `nvim` and `tmux` will automatically complete their post-configurations upon their first execution.

NOTE: These post-configurations need more prerequisites, which are auto-installed before and properly configured in `zshenv`. Thus it is recommended to first enter `zsh` and use `tmux` and `nvim` from there. The locations of auto-installed binaries (including `zsh`, `nvim` and `tmux`) are not in `$PATH` by default. If you wish to use them in another shell (e.g. `bash`), please refer to the "mungle PATH" part of `zshenv`.

You may need to setup the login shell yourself if it was not `zsh`.

If you wish to change the login shell to the auto-installed `zsh` but don't have the permission to modify `/etc/shells`, consider use this trick:
```bash
# At the end of ~/.bash_profile
# Be careful, this is kinda dangerous
exec ~/.conda/envs/app/bin/zsh
```
