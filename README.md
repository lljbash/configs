# Configs

My linux cli workspace configurations (e.g. dot files, useful snippets, color schemes, etc.).

## Bootstrap

If you want a one-step setup to reproduce my current workspace, there is a bootstrap procedure available.

**NOTE**: This procedure may mess up your current environment. Please refer to `justfile` for more details.

### Fonts

You have to use a [Nerd Font](https://www.nerdfonts.com/) patched font to correctly show the icons.

~~I am using [FiraCodeNF](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraCode.zip) for normal text and [SourceCodeProNF](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/SourceCodePro.zip) for italic text.~~

~~If your terminal (e.g. Windows Terminal) does not allow separated font settings for normal and italic text, consider use [fira-code-italic-fallback](https://github.com/lljbash/fira-code-italic-fallback), which is called FiraCodeNF-MediumItalic but is actually slightly-tweaked SourceCodeProNF-MediumItalic.~~

I am using [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.tar.xz) now.

### Setup

```bash
make bootstrap
```

This will first check the prerequisites (see `check_apps.sh`). If any are missing, you may need to install them manually. Running `make bootstrap-root` will install most prerequisites globally on Ubuntu, provided you have root permissions. The `make install-miniconda` command will install Miniconda3 in your home directory, providing `python`.

Once the prerequisites are in place, the setup will automatically configure everything. `zsh`, `nvim` and `tmux` will complete their post-configurations automatically upon first execution (you may need to restart them to complete their post-configurations).

If zsh isn’t set as your login shell, you may need to configure it manually by running `make set-login-shell`.

If you want to switch to a manually installed `zsh` but lack permission to modify `/etc/shells`, consider using the following workaround:

```bash
# At the end of ~/.bash_profile
# Be careful, this is kinda dangerous
exec PATH_TO_YOUR_ZSH
```
