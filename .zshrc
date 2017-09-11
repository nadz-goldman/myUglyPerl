
autoload -U compinit
compinit
autoload -U incremental-complete-word
zle -N incremental-complete-word
autoload -U insert-files
zle -N insert-files
autoload -U predict-on
zle -N predict-on


#tail ~ilya/ololo/NOT_BACKUP.txt

#if [ ${SHLVL} -eq 1 ]; then
#    ((SHLVL+=1)); export SHLVL
#    exec screen -R -e "^Ee" ${SHELL} -l
#fi


###
### Cvetastyj prompt i chasiki
###

#PROMPT=$'%{\e[1;32m%}[%{\e[1;34m%}%~%{\e[1;32m%}]%{\e[1;32m%}%#%{\e0%} '
#RPROMPT=$'%{\e[1;32m%}[%{\e[1;34m%}%T%{\e[1;32m%}]%{\e0%}'
#PROMPT=$'%{\e[1;32m%}[%{\e[1;34m%}%T%  %~%{\e[1;32m%}]%{\e[1;32m%}%#%{\e0%} '
#PROMPT=$'%T%  %~%  # '
PROMPT=$'%T %n@%M [%B%d%b]%# '



###
### HISTORY!
###

HISTFILE=~/.ZSh_history
SAVEHIST=5000
HISTSIZE=5000

setopt APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS


export EDITOR  ee
export VISUAL  ee
export PAGER   less
export BLOCKSIZE       K


BLOCKSIZE=K;            export BLOCKSIZE
EDITOR=mcedit;          export EDITOR
PAGER=less;             export PAGER
#LANG=ru_RU.KOI8-R;      export LANG
LC_TIME=POSIX;          export LC_TIME


###############
##  ALIASES  ##
###############

alias w="cd /usr/local/www/"
alias u="cd /usr/local/etc/"
alias v="cd /var/log/"
alias n="cd /usr/local/etc/nagios"
alias l="ls -AFGSahl"
alias t="telnet"
alias p="ping"
alias sh="cat"
alias i="grep -iE "
alias e="grep -viE "
alias en="su -m"

alias core="telnet 89.223.96.1"
alias invader="telnet 10.0.0.1"
alias meta="telnet 10.0.9.1"
alias bg="telnet 89.223.110.101"
alias sce="telnet 89.223.110.106"


echo "================================"
last -10
echo "================================"
who
echo "================================"
df -h
echo "================================"


##### bindings! olololo =)

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix


###
### Dopolnyahi stroki i prochee
###

zmodload -a zsh/zpty zpty
zmodload -a zsh/zprof zprof
zmodload -ap zsh/mapfile mapfile
zmodload -a zsh/stat stat

### cveta
### completishny


zstyle ':completion:*' completer _complete _list _oldlist _expand _ignored _match _correct _approximate _prefix
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' add-space true
zstyle ':completion:*:default' list-colors '${LS_COLORS}'
zstyle ':completion:*:processes' command 'ps -xuf'
zstyle ':completion:*:processes-names' command 'ps xho command'
zstyle ':completion:*:processes' sort true
zstyle ':completion:*:cd:*' ignore-parents parent pwd
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' menu select=long-list select=0
zstyle ':completion:*' old-menu false
zstyle ':completion:*' original true
zstyle ':completion:*' substitute 1
zstyle ':completion:*' use-compctl true
zstyle ':completion:*' verbose true
zstyle ':completion:*' word true



