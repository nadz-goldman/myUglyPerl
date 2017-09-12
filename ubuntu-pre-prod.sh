#!/bin/bash

########################################
#
# Ilya Vasilyev aka Nadz Goldman
# 2017
# ilya@arviol.ru
# 
########################################






if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo "Making locales more candy"

locale-gen en_US en_US.UTF-8 ru_RU ru_RU.UTF-8
dpkg-reconfigure locales
export LC_ALL="ru_RU.UTF-8"



echo "Updating info from repo and upgrading packages"

apt-get update -y
apt-get upgrade -y



echo "Removing bad and installing good packages"

apt-get remove -y apparmor whoopsie avahi-daemon ristretto apport gnome-screensaver
apt-get install -y --no-install-recommends  mc zsh sshfs exfat-fuse exfat-utils aptitude git locate glances atop htop nmap unzip p7zip p7zip-rar rar unrar-free p7zip-full tcpdump ntpdate


echo "chmod-ing not usable services in Ubuntu"

chmod -x /etc/init.d/apport
chmod -x /etc/init.d/avahi-daemon
chmod -x /etc/init.d/bluetooth
chmod -x /etc/init.d/brltty
chmod -x /etc/init.d/cups
chmod -x /etc/init.d/cups-browsed
chmod -x /etc/init.d/nmbd
chmod -x /etc/init.d/rsync
chmod -x /etc/init.d/samba
chmod -x /etc/init.d/samba-ad-dc
chmod -x /etc/init.d/saned
chmod -x /etc/init.d/smbd
chmod -x /etc/init.d/speech-dispatcher
chmod -x /etc/init.d/unattended-upgrades
chmod -x /etc/init.d/winbind




echo "Disabling MOtD"

chmod -x /etc/update-motd.d/*


echo "Setting ntpdate to crontab"

cat << EOF >> /etc/crontab


10      1       *       *       *       root  ntpdate  ntp4.vniiftri.ru
10      10      *       *       *       root  ntpdate  ntp2.vniiftri.ru

EOF



echo "Installing .zshrc"


cat << EOF > ~root/.zshrc


autoload -U compinit
compinit
autoload -U incremental-complete-word
zle -N incremental-complete-word
autoload -U insert-files
zle -N insert-files
autoload -U predict-on
zle -N predict-on



###
### Cvetastyj prompt i chasiki
###

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

alias v="cd /var/log/"
alias l="ls -AFGSahl"
alias t="telnet"
alias p="ping"
alias sh="cat"
alias i="grep -iE "
alias e="grep -viE "
alias en="sudo su -m"



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

bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

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



EOF



echo "Making .vimrc"

cat << EOF > ~root/.vimrc

version 6.0
if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
let &cpo=s:cpo_save
unlet s:cpo_save
set background=dark
set backspace=indent,eol,start
set fileencodings=ucs-bom,utf-8,default,latin1
set helplang=en
set history=50
set nomodeline
set printoptions=paper:a4
set ruler
set runtimepath=~/.vim,/var/lib/vim/addons,/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after,/var/lib/vim/addons/after,~/.vim/after
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
" vim: set ft=vim :

EOF


echo "Disabling IPv6"

echo "### Disable IPv6" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.conf
echo "net.ipv6.conf.lo.disable_ipv6 = 1" >> /etc/sysctl.conf

sysctl -p

echo "If you see 1 below this line, then IPv6 disabled. If not - try again"

cat /proc/sys/net/ipv6/conf/all/disable_ipv6


echo "All done, folks!"
