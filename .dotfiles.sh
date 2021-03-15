#!/bin/sh
if whoami | grep 'root' ; then
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
if sudo -v | grep -i 'Sorry' ; then
	SUDOER='no'
else
	SUDOER='yes'
fi
if echo "$OS_LIKE" | grep -i 'arch' ; then
	echo 'arch-based'
	:wsudo pacman -S --noconfirm zsh vim wget curl xsel
elif echo "$OS_LIKE" | grep -i 'debian' ; then
	echo 'debian-based'
	sudo apt update -y
	sudo apt install -y zsh vim wget curl xsel
elif echo "$OS_LIKE" | grep -i 'suse' ; then
	echo 'suse-based'
	sudo zypper refresh
	sudo zypper install zsh vim wget curl xsel
elif echo "$OS_LIKE" | grep -i 'fedora' ; then
	echo 'fedora-based'
	sudo dnf install zsh vim wget curl xsel
elif sw_vers | grep -i 'mac os' ; then
	echo 'FUCK this is mac' 
else
	echo 'OS not recognized :('
fi
# change shell to zsh
if echo "$SHELL" | grep -i 'zsh' ; then
	echo 'shell already zsh'
else
	sudo chsh -s /bin/zsh $USER
fi
# install oh-my-zsh without running zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# install vim-plug
curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# define git repo directory
DOTREPO=$HOME/.dotfiles
if git clone https://github.com/classy-crustacean/.dotfiles.git $DOTREPO 2>&1 | grep 'fatal' ; then
	echo 'repo already cloned'
	git -C $DOTREPO config pull.rebase false
	git -C $DOTREPO pull
else
	git -C $DOTREPO config pull.rebase false
fi
cp $DOTREPO/sunaku-minimal.zsh-theme $HOME/.oh-my-zsh/themes/
cp $DOTREPO/sunaku-minimal-user.zsh-theme $HOME/.oh-my-zsh/themes/
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="sunaku-minimal-user"/' $HOME/.zshrc
if !  grep -q 'source .*/\.dotfiles/\.zshrc' $HOME/.zshrc ; then
	echo source $DOTREPO/.zshrc
	echo source $DOTREPO/.zshrc >> $HOME/.zshrc
fi
if ! grep -q 'source .*/\.dotfiles/\.vimrc' $HOME/.vimrc ; then
	echo source $DOTREPO/.vimrc
	echo source $DOTREPO/.vimrc >> $HOME/.vimrc
fi
vim -c ':PlugInstall | quit | quit'
