# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi


# NVM
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion


# pnpm
export PNPM_HOME="/Users/jacobheim/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# set editor
export EDITOR=nvim

## Yazi Explorer
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# aliases
alias ls="eza -l --icons --no-permissions --no-user --no-time --no-filesize"
alias la="eza -l -a --icons --no-permissions --no-user --no-time --no-filesize --group-directories-first"
alias l.='eza -l -a --icons --no-permissions --no-user --no-time --no-filesize | egrep "^\."'
alias lsd="eza -l -s date --icons --no-permissions --no-user"
alias python="python3"
alias pip="pip3"
alias ..="cd .."
alias .2="cd ../.."
alias .3="cd ../../.."
alias cdh="cd ~"

# homebrew aliases
alias bi="brew install"

# pnpm aliases
alias pdev="pnpm run dev"


# use eza with tree view
function tree() {
    if [ "$1" != "" ]
    then
        eza -T $@
    else
        eza -T -L 2
    fi
}

#copy current working dir
function cpwd() {
    pwd | tr -d '\n' | pbcopy
}


# tproj
export PATH="/Users/jacobheim/tproj":$PATH


# zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load Completions
autoload -U compinit && compinit

zinit cdreplay -q


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase

setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
# This should be arrow keys, they dont work
bindkey '^[A' history-search-backward
bindkey '^[B' history-search-forward

# Completion Styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors '${(s.:.)LS_COLORS}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:*' continuous-trigger 'tab'
# zstyle ':fzf-tab:*' fzf-bindings 'space:accept'
zstyle ':fzf-tab:*' accept-line space

# alias ls='ls --color'

# fzf shell integration
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

eval "$(starship init zsh)"
