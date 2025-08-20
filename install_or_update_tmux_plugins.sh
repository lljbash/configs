#!/usr/bin/env bash
# install_or_update_tmux_plugins.sh
# Usage: ./install_or_update_tmux_plugins.sh <install|install-shallow|update>
# Defaults: TMUX_CONF=$HOME/.tmux.conf, PLUGIN_DIR=$HOME/.tmux/plugins
set -euo pipefail

MODE="${1:-}"   # must be one of: install, install-shallow, update
if [ -z "$MODE" ]; then
  cat <<EOF
Usage: $0 <install|install-shallow|update>

  install         : clone each plugin as a full clone (history included)
  install-shallow : clone each plugin with --depth 1 (small, fast)
  update          : for each existing plugin (with .git) try to update;
                    supports both shallow and full clones
Defaults: TMUX_CONF=\$HOME/.tmux.conf, PLUGIN_DIR=\$HOME/.tmux/plugins
EOF
  exit 1
fi

TMUX_CONF="${TMUX_CONF:-${HOME:-/root}/.tmux.conf}"
PLUGIN_DIR="${PLUGIN_DIR:-${HOME:-/root}/.tmux/plugins}"
mkdir -p "$PLUGIN_DIR"

# parse plugin lines like: set -g @plugin 'owner/repo' or 'owner/repo#branch' or full URL
grep -E "^[[:space:]]*set[[:space:]]+-g[[:space:]]+@plugin" "$TMUX_CONF" \
  | sed -E "s/.*@plugin[[:space:]]+['\"]([^'\"]+)['\"].*/\1/" \
  | while IFS= read -r repo_raw; do
    repo="$(printf '%s' "$repo_raw" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')"
    [ -z "$repo" ] && continue

    branch=""
    repo_no_branch="$repo"
    if printf '%s' "$repo" | grep -q '#'; then
      branch="${repo##*#}"
      repo_no_branch="${repo%%#*}"
    fi

    # decide URL
    if printf '%s' "$repo_no_branch" | grep -qE '^https?://|^git@|^ssh://'; then
      url="$repo_no_branch"
    else
      if printf '%s' "$repo_no_branch" | grep -q '/'; then
        url="https://github.com/${repo_no_branch}.git"
      else
        echo "Warning: skip unknown plugin format: $repo" >&2
        continue
      fi
    fi

    plugin_name="$(basename "${repo_no_branch}" .git)"
    target="$PLUGIN_DIR/$plugin_name"

    case "$MODE" in
      install)
        if [ -d "$target" ]; then
          echo "Skip (exists): $plugin_name"
        else
          echo "Cloning (full) $url -> $target"
          if [ -n "$branch" ]; then
            git clone --single-branch --branch "$branch" "$url" "$target" || { echo "Clone failed: $url" >&2; continue; }
          else
            git clone "$url" "$target" || { echo "Clone failed: $url" >&2; continue; }
          fi
        fi
        ;;
      install-shallow)
        if [ -d "$target" ]; then
          echo "Skip (exists): $plugin_name"
        else
          echo "Cloning (shallow) $url -> $target"
          if [ -n "$branch" ]; then
            git clone --depth 1 --single-branch --branch "$branch" "$url" "$target" || { echo "Clone failed: $url" >&2; continue; }
          else
            git clone --depth 1 --single-branch "$url" "$target" || { echo "Clone failed: $url" >&2; continue; }
          fi
        fi
        ;;
      update)
        if [ ! -d "$target" ]; then
          echo "Missing (not installed): $plugin_name"
          continue
        fi
        if [ ! -d "$target/.git" ]; then
          echo "No .git for $plugin_name — cannot update (was .git removed?)." >&2
          continue
        fi
        (
          set -e
          cd "$target"
          # resolve branch to update
          cur_branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || true)"
          if [ -z "$cur_branch" ] || [ "$cur_branch" = "HEAD" ]; then
            cur_branch="$(git remote show origin 2>/dev/null | sed -n 's/  HEAD branch: //p' || true)"
          fi
          # if .tmux.conf specified branch, prefer it
          if [ -n "$branch" ]; then
            cur_branch="$branch"
            git remote set-head origin -a 2>/dev/null || true
          fi
          echo "Updating $plugin_name (branch: ${cur_branch:-HEAD})"

          # detect shallow repo
          is_shallow="false"
          if git rev-parse --is-shallow-repository >/dev/null 2>&1; then
            is_shallow="$(git rev-parse --is-shallow-repository 2>/dev/null || true)"
          fi

          if [ "$is_shallow" = "true" ]; then
            # shallow: fetch shallow latest and reset to it
            git fetch --depth=1 origin "${cur_branch:-HEAD}" || git fetch --depth=1 origin || true
            git reset --hard FETCH_HEAD || true
          else
            # try fast-forward pull; if fails, fallback to regular pull
            git pull --ff-only origin "${cur_branch:-HEAD}" || git pull origin "${cur_branch:-HEAD}" || true
          fi
        )
        ;;
      *)
        echo "Unknown mode: $MODE" >&2
        exit 2
        ;;
    esac
done

echo "Done. Plugins under: $PLUGIN_DIR"
