# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

### XDG Part ###
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share" 
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/run/user/$UID"

## Prompt theming setup
## for starship
eval "$(starship init zsh)"
if [ ! -d "$XDG_CONFIG_HOME/starship" ]; then
   mkdir -p "$XDG_CONFIG_HOME/starship"
   touch "$XDG_CONFIG_HOME/starship/starship.toml"
fi
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

#@ for spaceship
# if [ ! -d "$XDG_CONFIG_HOME/spaceship" ]; then
#    mkdir -p "$XDG_CONFIG_HOME/spaceship"
#    touch "$XDG_CONFIG_HOME/spaceship/spaceship.zsh"
# fi
# export SPACESHIP_CONFIG="$XDG_CONFIG_HOME/spaceship/spaceship.zsh"

## zinit setup
# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# # Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use
# zinit light spaceship-prompt/spaceship-prompt

# # Add in snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::sudo
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::aws
# zinit snippet OMZP::kubectl
# zinit snippet OMZP::kubectx
# zinit snippet OMZP::command-not-found

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

zle_highlight+=(paste:none)

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

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

### ALIASES ###
## aliases file
[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f ~/.function-aliases ]] && . ~/.function-aliases


#create a file called .zshrc-personal and put all your personal aliases
#in there. They will not be overwritten by skel.

[[ -f ~/.zshrc-personal ]] && . ~/.zshrc-personal

## Functions
# toggle kitty theme transparency
toggle_kitty_transparency() {
    local dir="~/.dotfiles/kitty/.config/kitty"
    if [[ -d "$dir" ]]; then
		sh ~/.dotfiles/kitty/.config/kitty/toggle-opacity.sh
    else
		sh ~/.config/kitty/toggle-opacity.sh
    fi
}

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

## Decor
# if [[ $- == *i* ]] && command -v fastfetch &> /dev/null; then
#     fastfetch --config examples/17.jsonc
# fi