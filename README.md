# dotfiles

My dotfiles. Shell, terminal, editor, and AI-agent config for Windows 11 + WSL2 (Ubuntu, zsh, linuxbrew) and macOS (Apple Silicon).

Everything under `home/` mirrors `$HOME` exactly: `home/.zshrc -> ~/.zshrc`, `home/.config/git/ignore -> ~/.config/git/ignore`, and so on. `install.sh` symlinks each managed path to the repo copy. After install, edit in `~/dotfiles`; changes are live immediately.

New machines get set up agentically: the bootstrap steps below are written to be followed verbatim by a coding agent or a human. Credentials are manual on purpose; an agent has to stop and ask.

## New PC bootstrap (Windows + WSL2)

Follow these in order on a bare Windows 11 machine.

### 1. Windows side

1. Install WSL from an elevated PowerShell: `wsl --install` (installs Ubuntu by default), then reboot and create your UNIX user.
2. Optional Windows apps: `winget import windows/winget-apps.json` restores the exported Windows app list (see `windows/`).
3. Install the FiraCode Nerd Font on Windows (used by the terminal and starship glyphs).
4. Windows Terminal color scheme: add `windows/windows-terminal/catppuccin-mocha.json` contents to the WT `settings.json` schemes array and assign it to the WSL profile. This file is reference only; WT settings live on the Windows side and are not symlinked.

### 2. Inside WSL

```bash
# Base build deps for Homebrew
sudo apt-get update && sudo apt-get install -y build-essential curl file git

# Homebrew on Linux
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# This repo
git clone https://github.com/Thinnesen/dotfiles ~/dotfiles

# Restore the brew-installed toolchain (zsh, starship, eza, bat, nvim, gh, ...)
brew bundle --file ~/dotfiles/Brewfile

# Symlink the dotfiles (preview first, then apply)
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

Notes:

- `install.sh` is idempotent and careful. Real files are backed up as `<path>.pre-dotfiles.<timestamp>` before being replaced, and symlinks that point anywhere other than this repo are reported and left alone unless you pass `--adopt`.
- zsh is launched from `~/.bashrc` via a guarded `exec` (WSL friendly, no `chsh`). Escape hatch: `NO_ZSH=1 bash`.
- tmux plugins are TPM managed and not tracked: `git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`, then `prefix + I` inside tmux to install plugins.
- Neovim is a LazyVim setup; plugins install themselves on first `nvim` launch (pinned by `lazy-lock.json`).
- The Brewfile also records `go`, `uv`, `npm`, and `winget` package lines captured by `brew bundle dump`; recent brew bundle versions restore these too.

### 3. Credentials, by hand on purpose

These mint credentials, so they are deliberately not in the repo and not automated. An agent doing machine setup has to stop and ask me for each one:

1. `gh auth login` (recreates `~/.config/gh/hosts.yml`, which holds the GitHub OAuth token).
2. `claude` first run login (recreates `~/.claude/.credentials.json`).
3. Generate a new SSH keypair if needed: `ssh-keygen -t ed25519`, then add the public key to GitHub. Private keys are never tracked.
4. Git identity is tracked in `home/.gitconfig`; verify it with `git config user.name` after install.
5. Herdr integration: `~/.claude/settings.json` references `~/.claude/hooks/herdr-agent-state.sh`, which the herdr integration installs and overwrites itself. Reinstall herdr (it is in the Brewfile) and run its Claude integration setup. Until then that one SessionStart hook is a harmless no-op failure.
6. The everything-claude-code plugin populates `~/.claude/scripts/` (hook runners referenced by `settings.json`) and skills. It installs itself from the marketplaces declared inside the tracked `settings.json` on first Claude Code run.

## Setup on macOS

Running on my Mac since July 2026. The look: WezTerm (rose-pine-moon, Hack Nerd Font, transparency + blur), herdr as the terminal workspace manager (tmux-style binds on a `ctrl+space` prefix), and nvim in the matching rose-pine colorscheme. Run `./install.sh --dry-run` first and skim "Known differences on macOS" below before applying.

```bash
# 1. Xcode command line tools (compilers, git)
xcode-select --install

# 2. Homebrew (the installer prints a shellenv line for your shell; run it once
#    so brew is on PATH for the rest of this session)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 3. This repo (must live at ~/dotfiles, or set DOTFILES_DIR)
git clone https://github.com/Thinnesen/dotfiles ~/dotfiles

# 4. Optional: package managers used by the Brewfile's go/uv lines
brew install go uv

# 5. Restore the toolchain
brew bundle --file ~/dotfiles/Brewfile

# 6. Symlink the dotfiles (preview first, then apply)
cd ~/dotfiles
./install.sh --dry-run
./install.sh
```

The Brewfile's `wezterm` and `font-hack-nerd-font` casks cover the terminal and the Nerd Font on macOS (WSL uses Windows Terminal + FiraCode instead).

WezTerm's background shows the desktop wallpaper (dimmed) rather than real translucency, so other windows never bleed through. It reads a copy at `~/.local/share/wezterm/background.png`; after changing wallpaper, refresh it with:

```bash
mkdir -p ~/.local/share/wezterm
cp "$(osascript -e 'tell app "Finder" to get POSIX path of (get desktop picture as alias)')" ~/.local/share/wezterm/background.png
```

If the copy is missing, the config falls back to normal 80% translucency + blur.

Then open a new terminal: `.zshrc` detects Homebrew at `/opt/homebrew` (Apple Silicon), `/usr/local` (Intel), or linuxbrew, in that order, and silently skips tools that are not installed yet.

Credential checklist after install (same as WSL, manual on purpose):

1. `gh auth login`
2. `claude` first-run login
3. `ssh-keygen -t ed25519` and add the public key to GitHub if this Mac needs push access
4. Verify identity: `git config user.name`

### Known differences on macOS

These pieces are Windows/WSL-only and are skipped or inert on a Mac; everything else applies cleanly.

1. The `windows/` folder (Windows Terminal scheme, winget export) is reference material for the Windows host only.
2. The Brewfile's `winget` lines are Windows apps. brew bundle only acts on them under WSL and skips them on macOS, so `brew bundle` will not die on them.
3. The Brewfile's `go`, `uv`, and `npm` lines need that package manager on PATH; step 4 above covers go and uv, and node comes from the Brewfile itself before the npm lines run. Missing managers cause a skip warning, not a hard failure.
4. `.bashrc`'s hand-off to linuxbrew zsh is guarded by a linuxbrew path check and does nothing on macOS (the default login shell is already zsh). The rest of `.bashrc` works if bash is ever used.
5. `.claude/settings.json` hook commands use `$HOME` and are portable. The `mcpmarket-me` marketplace entry uses a `~/`-prefixed path. Claude Code documents `~/` support for path settings, but not explicitly for marketplace entries; if that marketplace stops resolving on the WSL machine, restore the absolute WSL home path. JSON fields never expand `$HOME`. On a Mac the marketplace resolves only if `~/.claude/plugins/mcpmarket-me` exists, and Claude Code continues without it.
6. The tmux, starship, bat, fastfetch, gh, git, and nvim configs contain no platform-specific paths and work unchanged. tmux clipboard uses OSC 52, which works in iTerm2, Terminal.app, and most modern terminals.
7. `install.sh` was verified against macOS constraints: stock bash 3.2 compatible (no associative arrays, no mapfile, no `${var,,}`), BSD userland compatible (`readlink` without `-f`, no `sed -i`, no `stat`), and shellcheck-clean.

## What is tracked and why

Every path in `$HOME` got an explicit include or exclude decision, so nothing sneaks into the repo by accident:

| Path (in `$HOME`) | Decision | Reason |
|---|---|---|
| `.zshrc` | include | Main shell config (brew, PATH, aliases, fzf incl. Ctrl+R history, starship init) |
| `.bashrc` | include | Hands interactive sessions to zsh; fallback bash setup |
| `.profile` | exclude | Stock Ubuntu default, effectively unmodified |
| `.bash_logout` | exclude | Stock Ubuntu default |
| `.tmux.conf` | include | Full tmux config incl. TPM plugin list |
| `.tmux/plugins/` | exclude | TPM managed state, restored by TPM |
| `.gitconfig` | include | Identity, gh credential helper (resolved from PATH), delta include, optional `~/.gitconfig.local` include for machine-local values |
| `.config/git/ignore` | include | Global gitignore |
| `.config/git/delta.gitconfig` | include | Delta pager config (imported from the old local-only repo) |
| `.config/gh/config.yml` | include | gh preferences and aliases, no secrets |
| `.config/gh/hosts.yml` | exclude | Holds the GitHub OAuth token |
| `.config/starship.toml` | include | Prompt config (minimal: dir, git, duration, `❯`) |
| `.config/wezterm/` | include | WezTerm config (rose-pine-moon, Hack Nerd Font, transparency + blur); macOS-only, inert elsewhere |
| `.config/herdr/config.toml` | include | herdr keybinds (tmux-style `ctrl+space` prefix) + rose-pine theme; file-level link because the rest of `.config/herdr/` is runtime state (sockets, logs, session) |
| `.config/bat/` | include | bat config plus Catppuccin theme |
| `.config/fastfetch/` | include | Splash config |
| `.config/nvim/` | include | LazyVim config incl. `lazy-lock.json` pins |
| `.local/share/nvim`, caches | exclude | Plugin and runtime state, restored by lazy.nvim |
| `.claude/settings.json` | include | My Claude Code settings incl. hook wiring (no secrets, audited) |
| `.claude/CLAUDE.md` | include | Global instructions |
| `.claude/rules/` | include | Rules I installed and edit |
| `.claude/agents/` | include | Agent definitions I installed and edit |
| `.claude/settings.local.json` | exclude | Machine-local permission grants; the global gitignore also excludes this pattern |
| `.claude/keybindings.json` | n/a | Does not exist on this machine |
| `.claude/.credentials.json` | exclude | Claude credentials |
| `.claude/projects`, `todos`, `sessions`, `shell-snapshots`, `history.jsonl`, logs | exclude | Session and runtime state |
| `.claude/skills/`, `plugins/`, `scripts/`, `hooks/` | exclude | Plugin-managed (everything-claude-code, MCPmarket, herdr); reinstalled by their installers |
| `.claude.json` | exclude | Claude Code runtime state, may embed tokens |
| `.ssh/` | exclude | Only keys and known_hosts exist (no `config` file); keys are never tracked |
| `.zsh_history`, `.bash_history`, `.zcompdump`, `.viminfo`, `.wget-hsts` | exclude | Histories and caches |
| `.npmrc`, `.env*` | n/a | Do not exist on this machine |

## Secret handling

No secrets ever reach this repo, private or not. The initial import was audited file by file, and the pattern for anything secret or machine-local is simple:

1. Put it in a git-ignored local file, for example `~/.zshrc.local`.
2. The tracked `.zshrc` already sources it: `[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"`.
3. The same idea works elsewhere: git supports `[include] path = ~/.gitconfig.local`, tmux supports `source-file -q ~/.tmux.conf.local`. Add the include line to the tracked file and keep the local file out of the repo.

## History

This repo absorbed an older, local-only `~/dotfiles` repo (zsh, starship, bat, atuin, fastfetch, delta, windows-terminal), then spent its first weeks named `dotfiles_2026` before taking over the `dotfiles` name itself. If a machine still has the old local-only `~/dotfiles` directory, move it aside before cloning this repo there; `./install.sh --adopt` then migrates any symlinks still pointing at the old copy, backing each one up first.
