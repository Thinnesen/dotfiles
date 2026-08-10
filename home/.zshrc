# ~/.zshrc, managed in ~/dotfiles (symlinked)

# Machine-local overrides and secrets live outside the repo:
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

# --- Homebrew: macOS Apple Silicon, macOS Intel, then Linuxbrew; skip if absent ---
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
  if [ -x "$_brew" ]; then
    eval "$("$_brew" shellenv)"
    break
  fi
done
unset _brew

# --- PATH ---
# /usr/local/bin before brew: Automic Vault's hardened stubs (npm, ...) live there
# and must shadow the real binaries they wrap (see `av doctor`).
export PATH="$HOME/.local/bin:$HOME/.local/go/bin:$HOME/go/bin:/usr/local/bin:$PATH"

# --- Editor ---
export EDITOR="nvim"
export VISUAL="nvim"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY          # share history across sessions
setopt HIST_IGNORE_ALL_DUPS   # no duplicate entries
setopt HIST_IGNORE_SPACE      # commands starting with space are not saved
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# --- Shell options ---
setopt AUTO_CD                # `..` or a dir name alone cd's into it
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

# --- Completion ---
# Automic Vault chowns the brew tree to its service user, which compaudit would
# flag. Its launcher mirrors brew completions into a user-owned dir; prefer that
# mirror and drop the protected prefix dir from fpath (per `av` homebrew docs),
# so compaudit stays fully strict. Without av, use the brew prefix as usual.
_av_mirror="$HOME/.local/share/automic-vault/homebrew/zsh/site-functions"
if [ -d "$_av_mirror" ]; then
  fpath=("$_av_mirror" ${fpath:#$HOMEBREW_PREFIX/share/zsh/site-functions})
elif [ -n "$HOMEBREW_PREFIX" ]; then
  fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
unset _av_mirror
# User-managed completions: cask completions the av mirror skips because they
# resolve outside the brew prefix (e.g. _wezterm from the app bundle).
_user_fns="$HOME/.local/share/zsh/site-functions"
[ -d "$_user_fns" ] && fpath=("$_user_fns" $fpath)
unset _user_fns
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# --- Keybindings ---
bindkey -e
bindkey '^[[1;5C' forward-word    # Ctrl+Right
bindkey '^[[1;5D' backward-word   # Ctrl+Left
bindkey '^[[1;3C' forward-word    # Alt+Right
bindkey '^[[1;3D' backward-word   # Alt+Left
bindkey '^[[H'    beginning-of-line
bindkey '^[[F'    end-of-line
bindkey '^[[3~'   delete-char

# --- Modern CLI replacements ---
alias ls='eza --icons --group-directories-first'
alias l='eza -la --icons --group-directories-first --git'
alias ll='eza -l --icons --group-directories-first --git'
alias la='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'
alias cat='bat --paging=never'
alias vim='nvim'
alias vi='nvim'
alias grep='grep --color=auto'
alias lg='lazygit'
alias python='python3'

# --- Git aliases ---
alias ga='git add .'
alias gc='git commit -m "wip"'
alias gpush='git push'
alias gpull='git pull && git pull -f --tags'
alias gall='git add . && git commit -am "wip wip wip" && git push'

# --- tmux aliases ---
alias tlist='tmux list-session'
alias tattach='tmux attach-session -t'
alias tnew='tmux new -s'

# --- kubectl completion (skipped if not installed) ---
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# --- kubecolor: colorized kubectl output (skipped if not installed) ---
command -v kubecolor >/dev/null && alias kubectl='kubecolor'

# --- fzf: Catppuccin Mocha colors + fd as default source ---
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS=" \
--height=60% --layout=reverse --border=rounded \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --style=numbers --line-range=:200 {}'"

# --- Tool inits (each skipped if the tool is not installed yet) ---
if command -v fzf >/dev/null; then
  source <(fzf --zsh)                                                # Ctrl+R history, Ctrl+T files, Alt+C cd
elif [ -f "$HOME/.fzf.zsh" ]; then
  source "$HOME/.fzf.zsh"                                            # fallback: fzf installed via its install script
fi
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"            # `z foo` jumps by frecency; plain cd stays literal
command -v starship >/dev/null && eval "$(starship init zsh)"        # prompt

# --- Conda: lazy-loaded to keep shell startup fast ---
# Real init runs only on first `conda` call, then the shim removes itself and
# hands off to the real conda. Skipped entirely if miniconda is not installed.
if [ -d "$HOME/miniconda3" ]; then
  conda() {
    unset -f conda
    __conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
      eval "$__conda_setup"
    elif [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
      . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
      export PATH="$HOME/miniconda3/bin:$PATH"
    fi
    unset __conda_setup
    conda "$@"
  }
fi

# --- Autosuggestions + syntax highlighting (highlighting must be last) ---
if [ -f "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
  ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'
  bindkey '^f' autosuggest-accept
fi
if [ -f "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# --- Splash on fresh terminals (skip tmux/herdr panes, VS Code, nested shells) ---
if [[ -o interactive && -z "$TMUX" && -z "$HERDR_ENV" && "$TERM_PROGRAM" != "vscode" ]] && command -v fastfetch >/dev/null; then
  fastfetch
fi
