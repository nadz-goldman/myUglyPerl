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

# Sometimes some admins make local repos with very old packages

echo "Cleaning local repo"

R=$( lsb_release -c | awk '{print $2}' )
if [ "$R" = "trusty" ] ; then 
  echo "Ok, we have trusty here"
  mv /etc/apt/sources.list /etc/apt/sources.list-LOCAL
  echo "
deb http://ru.archive.ubuntu.com/ubuntu/ trusty main restricted
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty main restricted

deb http://ru.archive.ubuntu.com/ubuntu/ trusty-updates main restricted
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty-updates main restricted

deb http://ru.archive.ubuntu.com/ubuntu/ trusty universe
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty universe
deb http://ru.archive.ubuntu.com/ubuntu/ trusty-updates universe
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty-updates universe

deb http://ru.archive.ubuntu.com/ubuntu/ trusty multiverse
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty multiverse
deb http://ru.archive.ubuntu.com/ubuntu/ trusty-updates multiverse
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty-updates multiverse

deb http://ru.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse
deb-src http://ru.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse

deb http://security.ubuntu.com/ubuntu trusty-security main restricted
deb-src http://security.ubuntu.com/ubuntu trusty-security main restricted
deb http://security.ubuntu.com/ubuntu trusty-security universe
deb-src http://security.ubuntu.com/ubuntu trusty-security universe
deb http://security.ubuntu.com/ubuntu trusty-security multiverse
deb-src http://security.ubuntu.com/ubuntu trusty-security multiverse

deb http://archive.canonical.com/ubuntu trusty partner

deb http://extras.ubuntu.com/ubuntu trusty main
deb-src http://extras.ubuntu.com/ubuntu trusty main
" > /etc/apt/sources.list

else 
  echo "Hmmm... Not trusty? Nadz?"
fi


echo "Making locales more candy"

locale-gen en_US en_US.UTF-8 ru_RU ru_RU.UTF-8
dpkg-reconfigure locales
export LC_ALL="ru_RU.UTF-8"

echo "Updating info from repo and upgrading packages"

apt-get update -y
apt-get upgrade -y

echo "Lets remove bad and install good packages"

apt-get remove -y apparmor whoopsie avahi-daemon ristretto apport gnome-screensaver
apt-get install -y --no-install-recommends  mc zsh sshfs exfat-fuse exfat-utils aptitude git locate htop nmap zip unzip p7zip p7zip-rar rar unrar-free p7zip-full tcpdump ntpdate atop 

echo "chmod-ing out not usable services in Ubuntu"

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

echo "Disabling MOtD!!!!1111oneoneone"

chmod -x /etc/update-motd.d/*

echo "Setting ntpdate to crontab"

cat << EOF >> /etc/crontab


10      1       *       *       *       root  ntpdate  ntp4.vniiftri.ru
10      10      *       *       *       root  ntpdate  ntp2.vniiftri.ru

EOF

echo "Making .vimrc"

cat << EOF >> ~/.vimrc

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
set helplang=ru
set history=50
set nomodeline
set printoptions=paper:a4
set ruler
set number
set hlsearch
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

echo "Cleaning entities after removing"
aptitude purge ~c

echo "Updating locate database"
updatedb

echo "Disabling ufw"
ufw disable


echo "All done, folks!"
