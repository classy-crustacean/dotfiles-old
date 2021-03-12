#!/bin/sh
OS_LIKE=$(grep 'NAME\|ID_LIKE' /etc/os-release)
echo $OS_LIKE
if echo "$OS_LIKE" | grep -i 'arch' ; then
	echo 'arch-based'
	sudo pacman -S --noconfirm zsh vim wget curl
elif echo "$OS_LIKE" | grep -i 'debian' ; then
	echo 'debian-based'
elif echo "$OS_LIKE" | grep -i 'suse' ; then
	echo 'suse-based'
elif echo "$OS_LIKE" | grep -i 'fedora' ; then
	echo 'fedora-based'
elif sw_vers | grep -i 'mac os' ; then
	echo 'FUCK this is mac' 
else
	echo 'OS not recognized :('
fi
# change shell to zsh
chsh -s /bin/zsh
# install oh-my-zsh without running zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# define git repo directory
DOTREPO=$HOME/.dotfiles
git clone https://github.com/classy-crustacean/.dotfiles.git $DOTREPO
cp $DOTREPO/sunaku-minimal.zsh-theme $HOME/.oh-my-zsh/themes/
cp $DOTREPO/sunaku-minimal-user.zsh-theme $HOME/.oh-my-zsh/themes/
