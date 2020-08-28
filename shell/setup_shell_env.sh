#!/usr/bin/env bash

# $ curl https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/setup_shell_env.sh -L -o ~/setup_shell_env.sh
# $ wget https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/setup_shell_env.sh -O ~/setup_shell_env.sh

# rm ~/.my_bash_alias
# rm ~/.vimrc

# $1 targetdir
function makedir() {
  if [ ! -d $1 ]; then
    mkdir -p $1
  fi
}

# $1 url
# $2 path
function download() {
  if [ ! -f $2 ]; then
    echo "download $1 to $2"
    if [ -f /usr/bin/curl ]; then
      # /usr/bin/curl $1 -o $2
      /usr/bin/curl -L -s $1 -o $2
    elif [ -f /usr/bin/wget ]; then
      # /usr/bin/wget $1 -O $2
      /usr/bin/wget -q $1 -O $2
    fi
  fi
}

# Get Linux distribution name
get_os_distribution() {
    distri_name="unkown"
    if   [ -e /etc/debian_version ] ||
         [ -e /etc/debian_release ]; then
        # Check Ubuntu or Debian
        if [ -e /etc/lsb-release ]; then
            # Ubuntu
            distri_name="ubuntu"
        else
            # Debian
            distri_name="debian"
        fi
    elif [ -e /etc/fedora-release ]; then
        # Fedra
        : # distri_name="fedora"
    elif [ -e /etc/redhat-release ]; then
        if [ -e /etc/oracle-release ]; then
            # Oracle Linux
            : # distri_name="oracle"
        else
            # Red Hat Enterprise Linux
            distri_name="redhat"
        fi
    elif [ -e /etc/arch-release ]; then
        # Arch Linux
        : # distri_name="arch"
    elif [ -e /etc/turbolinux-release ]; then
        # Turbolinux
        : # distri_name="turbol"
    elif [ -e /etc/SuSE-release ]; then
        # SuSE Linux
        : # distri_name="suse"
    elif [ -e /etc/mandriva-release ]; then
        # Mandriva Linux
        : # distri_name="mandriva"
    elif [ -e /etc/vine-release ]; then
        # Vine Linux
        : # distri_name="vine"
    elif [ -e /etc/gentoo-release ]; then
        # Gentoo Linux
        : # distri_name="gentoo"
    else
        # Other
        distri_name="unkown"
    fi
}

get_os_distribution


##############################
### .vimrc, .my_bash_alias ###
##############################

RAW_GIT=https://raw.githubusercontent.com/thino-rma/PlayGround/master/shell/
TARGET=.vimrc
download ${RAW_GIT}/${TARGET} ~/${TARGET}
TARGET=.my_bash_alias
download ${RAW_GIT}/${TARGET} ~/${TARGET}

if ! grep "~/.my_bash_alias" ~/.bashrc > /dev/null; then
  echo ". ~/.my_bash_alias" >> ~/.bashrc
  . ~/.bashrc
fi

##################
### vim plugin ###
##################

VIM_DIR=~/.vim
AUTOLOAD_DIR=${VIM_DIR}/autoload
PLUGIN_DIR=${VIM_DIR}/plugin

# makedir $AUTOLOAD_DIR
# makedir $PLUGIN_DIR

### oscyank
# RAW_GIT=https://raw.githubusercontent.com/greymd/oscyank.vim/master
# TARGET=autoload/oscyank.vim
# download ${RAW_GIT}/${TARGET} ${VIM_DIR}/${TARGET}
# TARGET=plugin/oscyank.vim
# download ${RAW_GIT}/${TARGET} ${VIM_DIR}/${TARGET}

### TextYankPost
# RAW_GIT=https://raw.githubusercontent.com/ShikChen/osc52.vim/master
# TARGET=plugin/osc52.vim
# download ${RAW_GIT}/${TARGET} ${VIM_DIR}/${TARGET}

### packages
echo "### commands to instal packages ###"
if [ $distri_name = "debian" ] || [ $distri_name = "ubuntu" ]; then
  echo "sudo apt -y install curl wget vim"
fi
if [ $distri_name = "redhat" ]; then
  echo "# curl -L https://copr.fedorainfracloud.org/coprs/unixcommunity/vim/repo/epel-7/unixcommunity-vim-epel-7.repo -o /etc/yum.repos.d/unixcommunity-vim-epel-7.repo"
  echo "sudo yum -y install curl wget vim"
fi
