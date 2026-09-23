# Works on macOS and Linux/WSL. All `brew` formulae below exist in homebrew/core
# with macOS bottles (verified against formulae.brew.sh, 2026-07-22).
# - `winget` lines are Windows apps; brew bundle only acts on them under WSL and
#   skips them everywhere else (they are gated on OS.wsl? inside brew bundle).
# - `go`, `uv`, and `npm` lines need that package manager on PATH; brew bundle
#   skips them with a warning when it is missing.

# Clone of cat(1) with syntax highlighting and Git integration
brew "bat"
# Modern, maintained replacement for ls
brew "eza"
# Like neofetch, but much faster because written mostly in C
brew "fastfetch"
# Simple, fast and user-friendly alternative to find
brew "fd"
# Command-line fuzzy finder written in Go
brew "fzf"
# GNU compiler collection
brew "gcc"
# GitHub command-line tool
brew "gh"
# Syntax-highlighting pager for git and diff output
brew "git-delta"
# Agent multiplexer that lives in your terminal
brew "herdr"
# Lightweight and flexible command-line JSON processor
brew "jq"
# Simple terminal UI for git commands
brew "lazygit"
# Ambitious Vim-fork focused on extensibility and agility
brew "neovim"
# Extraction utility for .zip compressed archives
brew "unzip"
# Open-source, cross-platform JavaScript runtime environment
brew "node"
# Search tool like grep and The Silver Searcher
brew "ripgrep"
# Cross-shell prompt for astronauts
brew "starship"
# Shell extension to navigate your filesystem faster
brew "zoxide"
# UNIX shell (command interpreter)
brew "zsh"
# Fish-like fast/unobtrusive autosuggestions for zsh
brew "zsh-autosuggestions"
# Fish shell like syntax highlighting for zsh
brew "zsh-syntax-highlighting"
# Terminal-based AI coding assistant
cask "claude-code@latest"
# GPU-accelerated cross-platform terminal emulator (macOS only; skipped on Linux)
cask "wezterm"
# Hack Nerd Font, used by wezterm and starship glyphs (macOS only)
cask "font-hack-nerd-font"
go "github.com/golang-migrate/migrate/v4/cmd/migrate"
go "github.com/a-h/templ/cmd/templ"
uv "headroom-ai[all]"
# --- Windows apps via winget: applied only under WSL, skipped on macOS/Linux ---
winget "Claude", id: "Anthropic.Claude"
winget "Git", id: "Git.Git"
wiget "Python Launcher", id: "Python.Launcher"
winget "uv", id: "astral-sh.uv"
npm "bun"
npm "chrome-devtools-axi"
npm "gh-axi"
npm "lavish-axi"
npm "quota-axi"
npm "tasks-axi"
