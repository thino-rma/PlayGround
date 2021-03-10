_USER=`who am i | awk '{ print $1 }'`
if [ -f ~/.bash_aliases.${_USER} ]; then
    . ~/.bash_aliases.${_USER}
fi

if [ ! -f ~/.vimrc.${_USER} ]; then
if [ -f /home/${_USER}/.vimrc ]; then
    cp -a /home/${_USER}/.vimrc ~/.vimrc.${_USER}
fi    
fi

if [ -f /usr/bin/vim ]; then
    alias vim='vim -u ~/.vimrc.'${_USER}
fi
