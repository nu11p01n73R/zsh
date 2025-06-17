PROMPT=' %F{red}%n@%m%F{yellow} [ %1~ ]
%F{magenta} >>> %F{white}'
setopt promptsubst

export EDITOR="/opt/homebrew/bin/nvim"

export XDG_CONFIG_HOME="$HOME/.config"

setopt autocd

autoload -Uz compinit promptinit up-line-or-beginning-search down-line-or-beginning-search
promptinit
compinit

# Custom path
typeset -U path
path=(/usr/local/bin $path[@])

# Menu style auto completion
zstyle ':completion:*' menu select
setopt COMPLETE_ALIASES

# Search on key up/down
typeset -g -A key

key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"

zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start {
		echoti smkx
	}
	function zle_application_mode_stop {
		echoti rmkx
	}
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# Set vim mode
bindkey -v

# FZF 
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function offind() {
    nvim $(ffind)
}

# Aliases
alias ls="ls -alhG" 

alias ts="tmux new-session -s"
alias ta="tmux attach"

alias ga="git  add"
alias gs="git status"
alias gb="git branch"
alias gc="git commit"
alias gco="git checkout"
alias gd="git diff"
alias gp="git push"
alias gf="git fetch"
alias gl="git log"
alias glo="git log --oneline"

alias lg="lazygit"

alias ffind="fzf --preview='bat -n --color=always {}'"


# Functions

# Current branch name
git_branch() {
        ref=$(git symbolic-ref HEAD 2> /dev/null | cut -d'/' -f3)
        [[ -n "$ref" ]] && echo " $ref"
}

colors() {
	for i in {0..255}; do
    		printf "\x1b[38;5;${i}mcolour${i}\x1b[0m\n"
	done
}


# Colored man pages
function man() {
	env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			man "$@"
}

# Copy with progress
cpv() {
        rsync -h --progress "$@"
}


function tilde() {
        sudo hidutil property --set '{
            "UserKeyMapping":[
                {
                    "HIDKeyboardModifierMappingSrc":0x700000035,
                    "HIDKeyboardModifierMappingDst":0x700000035
                },
                {
                    "HIDKeyboardModifierMappingSrc":0x700000064,
                    "HIDKeyboardModifierMappingDst":0x700000064
                }
             ]
         }'
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
