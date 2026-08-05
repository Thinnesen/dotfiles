# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- This repo targets both WSL2/Linuxbrew and macOS. Portability rules: shell configs detect brew via the loop at the top of `home/.zshrc` (never hardcode a brew prefix); `home/.claude/settings.json` hook commands must use `$HOME`, never a hardcoded home path (hook commands run through a shell, so `$HOME` expands). Plain JSON path fields never expand `$HOME`; use `~/`-prefixed paths there (documented for path settings, unverified for marketplace entries - see README "Setup on macOS" item 5). Machine-local values go in git-ignored `~/.zshrc.local` / `~/.gitconfig.local`, both already included by the tracked files.
- The macOS story (bootstrap steps, what stays WSL-only, install.sh bash 3.2 and BSD constraints) is documented in README.md under "Setup on macOS"; keep that section updated when adding platform-specific config.
- Verify changes with: `./install.sh --dry-run` (must show 0 warnings, everything ok), `shellcheck install.sh`, and sourcing the changed rc file in a subshell (see README).

## Maintaining this file

Keep this file for knowledge useful to almost every future agent session in this project.
Do not repeat what the codebase already shows; point to the authoritative file or command instead.
Prefer rewriting or pruning existing entries over appending new ones.
When updating this file, preserve this bar for all agents and keep entries concise.
