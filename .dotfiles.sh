#!/bin/sh
if whoami | grep -iq 'root' ; then
	echo -n "Running as root will not install to the current user. Continue? (y/n)? "
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg
	if ! echo "$answer" | grep -iq "^y" ;then
		exit
	fi
fi
OS_LIKE=$(grep 'NAME\|ID_LIKE' /etc/os-release)
echo $OS_LIKE
if sudo -v | grep -iq 'Sorry' ; then
	SUDOER='no'
else
	SUDOER='yes'
fi
if [ SUDOER == yes ] ; then
	if echo "$OS_LIKE" | grep -iq 'arch' ; then
		echo 'arch-based'
		sudo pacman -S --noconfirm zsh vim wget curl xsel
	elif echo "$OS_LIKE" | grep -iq 'debian' ; then
		echo 'debian-based'
		sudo apt update -y
		sudo apt install -y zsh vim wget curl xsel
	elif echo "$OS_LIKE" | grep -iq 'suse' ; then
		echo 'suse-based'
		sudo zypper refresh
		sudo zypper install zsh vim wget curl xsel
	elif echo "$OS_LIKE" | grep -iq 'fedora' ; then
		echo 'fedora-based'q
		sudo dnf install zsh vim wget curl xsel
	elif sw_vers | grep -iq 'mac os' ; then
		echo 'mac os' 
	else
		echo 'OS not recognized :('
	fi
fi
# change shell to zsh
if echo "$SHELL" | grep -iq 'zsh' ; then
	echo 'shell already zsh'
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else 
	if chsh -s 'which zsh' ; then
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	fi
fi
# install vim-plug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# define git repo directory
DOTREPO=$HOME/.dotfiles
if git clone https://github.com/classy-crustacean/.dotfiles.git $DOTREPO 2>&1 | grep -iq 'fatal' ; then
	echo 'repo already cloned'
	git -C $DOTREPO config pull.rebase false
	git -C $DOTREPO pull
else
	git -C $DOTREPO config pull.rebase false
fi
# install themes
cp $DOTREPO/sunaku-minimal.zsh-theme $HOME/.oh-my-zsh/themes/
cp $DOTREPO/sunaku-minimal-user.zsh-theme $HOME/.oh-my-zsh/themes/
# set theme
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="sunaku-minimal-user"/' $HOME/.zshrc
# set dotrepo
echo 'DOTREPO='$DOTREPO
if ! grep -i 'DOTREPO='$DOTREPO $HOME/.zshrc ; then
	echo not included
	echo 'DOTREPO='$DOTREPO >> $HOME/.zshrc
fi
# source
if echo "$OS_LIKE" | grep -iq "mac os" ; then
	if ! grep -iq 'source $DOTREPO/\.zshrc.mac' $HOME/.zshrc ; then
		echo 'source $DOTREPO/.zshrc.mac'
		echo 'source $DOTREPO/.zshrc.mac' >> $HOME/.zshrc
		source $DOTREPO/.zshrc.mac
	fi
else
	if ! grep -iq 'source $DOTREPO/\.zshrc' $HOME/.zshrc ; then
		echo 'source $DOTREPO/.zshrc'
		echo 'source $DOTREPO/.zshrc' >> $HOME/.zshrc
		source $DOTREPO/.zshrc
	fi
fi
# dotrepo
if ! grep -iq "source $DOTREPO/\.vimrc" $HOME/.vimrc ; then
	echo "source $DOTREPO/.vimrc"
	echo "source $DOTREPO/.vimrc" >> $HOME/.vimrc
fi
vim -c ':PlugInstall | quit | quit'
