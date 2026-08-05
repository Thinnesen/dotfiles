#!/usr/bin/env bash
# install.sh, symlinks the dotfiles in this repo into $HOME.
#
# Usage:
#   ./install.sh            apply changes
#   ./install.sh --dry-run  print what would happen, change nothing
#   ./install.sh --adopt    also replace symlinks that point somewhere else
#                           (the old symlink is renamed to a backup first)
#
# Behavior per managed path:
#   - already the correct symlink        -> skip
#   - symlink pointing somewhere else    -> report; only replace with --adopt
#   - real file or directory             -> move to <path>.pre-dotfiles.<timestamp>, then symlink
#   - missing                            -> create parent dirs, then symlink
#
# The symlink target base is ~/dotfiles (override with DOTFILES_DIR).
# This script never links against a checkout other than DOTFILES_DIR.

set -euo pipefail

DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
DRY_RUN=0
ADOPT=0
STAMP="$(date +%Y%m%d-%H%M%S)"

for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --adopt)   ADOPT=1 ;;
    -h|--help) grep '^#' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "unknown argument: $arg" >&2; exit 1 ;;
  esac
done

if [ ! -d "$DOTFILES_DIR/home" ]; then
  echo "ERROR: $DOTFILES_DIR/home not found." >&2
  echo "Clone the repo to ~/dotfiles (or set DOTFILES_DIR) before running." >&2
  exit 1
fi

# Every entry is a path relative to $HOME; the repo copy lives at home/<entry>.
# Directories are linked as whole-directory symlinks.
MANAGED=(
  AGENTS.md
  .zshrc
  .bashrc
  .tmux.conf
  .gitconfig
  .config/git/ignore
  .config/git/delta.gitconfig
  .config/gh/config.yml
  .config/starship.toml
  .config/wezterm
  .config/herdr/config.toml
  .config/bat
  .config/fastfetch
  .config/nvim
  .claude/settings.json
  .claude/CLAUDE.md
  .claude/rules
  .claude/agents
)

linked=0 skipped=0 backed_up=0 warned=0

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] $*"
  else
    "$@"
  fi
}

for rel in "${MANAGED[@]}"; do
  src="$DOTFILES_DIR/home/$rel"
  dst="$HOME/$rel"

  if [ ! -e "$src" ]; then
    echo "MISSING source, skipping: $src" >&2
    warned=$((warned + 1))
    continue
  fi

  if [ -L "$dst" ]; then
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      echo "ok      $dst"
      skipped=$((skipped + 1))
      continue
    fi
    if [ "$ADOPT" -eq 1 ]; then
      echo "adopt   $dst (was symlink -> $current)"
      run mv "$dst" "$dst.pre-dotfiles.$STAMP"
      backed_up=$((backed_up + 1))
    else
      echo "WARN    $dst is a symlink to $current (expected $src); leaving it alone. Re-run with --adopt to replace it." >&2
      warned=$((warned + 1))
      continue
    fi
  elif [ -e "$dst" ]; then
    echo "backup  $dst -> $dst.pre-dotfiles.$STAMP"
    run mv "$dst" "$dst.pre-dotfiles.$STAMP"
    backed_up=$((backed_up + 1))
  fi

  run mkdir -p "$(dirname "$dst")"
  run ln -s "$src" "$dst"
  echo "link    $dst -> $src"
  linked=$((linked + 1))
done

# Register the bat theme so bat and git-delta find "Catppuccin Mocha".
if command -v bat >/dev/null 2>&1; then
  if [ "$DRY_RUN" -eq 1 ]; then
    echo "  [dry-run] bat cache --build"
  else
    bat cache --build >/dev/null && echo "bat theme cache rebuilt"
  fi
fi

echo
echo "done: $linked linked, $skipped already ok, $backed_up backed up, $warned warnings"
if [ "$warned" -gt 0 ]; then
  exit 2
fi
