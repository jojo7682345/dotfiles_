
source ~/.comfy_env

export DEBUG=false

$DEBUG && . $CONFIGPATH/.zsh_doc

$DEBUG && echo "-- configurating zsh"

export initial_shell=true
[[ ! -z "$ZSH" ]] && initial_shell=false
$DEBUG && { ! $initial_shell && echo "[ZSH($ZSH)]"; }

if $DEBUG; then
  export ZSH="$XDG_DEV_DIR/lime"
else
  export ZSH="$HOME/.saku/repo/lime"
fi
export ZSH_CUSTOM="$XDG_CONFIG_HOME/lime"

ZSH_THEME="aki"
ZSH_THEME_FILE="$ZSH_CUSTOM/themes/$ZSH_THEME.zsh-theme"

export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

$DEBUG && echo "-- configurating omz"

# ZSH config
zstyle ':omz:update' frequency 12
ENABLE_CORRECTION="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
autoload -U compinit && compinit
# compinit -i

bindkey -e

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=15'

# Highlighting
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[main]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[builtin]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[command]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta'

ZSH_HIGHLIGHT_STYLES[assign]='fg=cyan'

ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=green'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=green'

ZSH_HIGHLIGHT_STYLES[comment]='fg=gry'

ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=yellow'

# welcome message
WELCOME_CMD="HAEL_GENDER='fem' hael -r"
WELCOME_PIPE="kittysay -c 2 6"

# Plugins
plugins=(
 zsh-syntax-highlighting
 zsh-autosuggestions
 git
 tmux
 utils
 quickcd
)
$initial_shell && plugins+=welcome-message

DOTNET_CLI_TELEMETRY_OPTOUT=true

ZSH_TMUX_AUTOSTART=false
ZSH_TMUX_AUTOCONNECT=false
ZSH_TMUX_AUTOQUIT=false

# Dont check file permissions
ZSH_DISABLE_COMPFIX=true

$DEBUG && echo "-- loading lime"

source $ZSH/lime.sh

$DEBUG && echo "-- loading starship"

eval "$(starship init zsh)"

$DEBUG && echo "-- setting environment variables"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vi'
  export PAGER='less'
  export MANPAGER=$PAGER
else
  if command -v nvim &> /dev/null; then
    export EDITOR='nvim'
  else
    if command -v vi &> /dev/null; then
      export EDITOR='vi'
    else
      export EDITOR='nano'
    fi
  fi
  export PAGER='less'
  export MANPAGER='nvim +Man!'
fi

autoload edit-command-line; zle -N edit-command-line
bindkey "^w" edit-command-line

[[ ! -z "$TMUX" ]] && {
  socket_f="${XDG_RUNTIME_DIR}/nvim.$(basename `pwd`).0"
  alias v="(){ [[ -x $socket_f ]] && { nvim --server $socket_f --remote-silent \$@; } || { nvim --listen $socket_f \$@; } }"
}

# Sound
export HOST_IP="$(ip route |awk '/^default/{print $3}')"
#export PULSE_SERVER="tcp:$HOST_IP"
#export DISPLAY="$HOST_IP:0.0"

export CSGOCFG='/mnt/c/Program\ Files\ (x86)/Steam/userdata/1004638887/730/local/cfg/autoexec.cfg'

# fzf
export FZF_DEFAULT_OPTS='--margin=0,2 --padding="1" --height=16
--layout="reverse-list" --info=right
--preview-window="border-rounded"
--prompt="> " --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS"
  --color=fg:-1,fg+:15,bg:-1,bg+:-1
  --color=hl:11,hl+:15,pointer:5,marker:13
  --color=prompt:3,spinner:1,info:4,header:6
  --color=border:0,label:-1,query:-1"

source ~/.saku/root/state/shell-plugins/fzf-git/fzf-git.plugin.sh

_fzf_git_fzf() {
  fzf "$@"
}

# haikufetch
export HF_INFO="ascii title os kernel wm shell editor"
export HF_SEPARATOR=" on "

$DEBUG && echo "-- loading local scripts"

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}"
source "$DATA_DIR/wallctl/.wallpaperenv"

function tmux-attach {
  tmux attach
}
zle -N tmux-attach
bindkey "^A" tmux-attach
function tmux-detach {
  tmux detach
}
zle -N tmux-detach
bindkey "^X" tmux-detach

$DEBUG && echo "-- setting additional environment variables"

# ENV
export NOTES="$HOME/.notes"
export ZSHRC="$ZDOTDIR/.zshrc"

export FILE_MANAGER="yazi"

# nvm
export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# bun completions
#[ -s "/home/comfy/.bun/_bun" ] && source "/home/comfy/.bun/_bun"

# bun
export BUN_INSTALL="/home/comfy/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias last_commit='git log --oneline | head -n 1 | grep -oE " .*" | grep -oE "[^ ].*"'
test -r "~/.dir_colors" && eval $(dircolors ~/.dir_colors)
