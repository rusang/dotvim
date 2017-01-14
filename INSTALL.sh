#!/bin/bash

echo "Start install configs"
ln -s ~/.vim/vimrc ~/.vimrc
ln -s ~/.vim/gvimrc ~/.gvimrc
ln -s ~/.vim/tmux.conf ~/.tmux.conf
ln -s ~/.vim/config/vimrc ~/.vimrc
ln -s ~/.vim/config/zshrc ~/.zshrc
ln -s ~/.vim/config/vimrc ~/.gvimrc
sudo ln -s ~/.vim/script/mygl.sh   /usr/local/bin/mygl
sudo ln -s ~/.vim/script/backlight.sh  /usr/local/bin/backlight
sudo cp ~/.vim/lock_fancy/*     /usr/local/bin/
echo "END OF INSTALLED"

