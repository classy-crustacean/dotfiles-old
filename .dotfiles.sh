#!/bin/sh
OS_LIKE=$(grep 'NAME\|ID_LIKE' /etc/os-release)
echo $OS_LIKE
if echo "$OS_LIKE" | grep -i 'arch' ; then
	echo 'arch-based'
	sudo pacman -S --noconfirm zsh vim wget curl xsel
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
	sudo chsh -s /bin/zsh
fi
# install oh-my-zsh without running zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
# install vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# define git repo directory
DOTREPO=$HOME/.dotfiles
git clone https://github.com/classy-crustacean/.dotfiles.git $DOTREPO
cp $DOTREPO/sunaku-minimal.zsh-theme $HOME/.oh-my-zsh/themes/
cp $DOTREPO/sunaku-minimal-user.zsh-theme $HOME/.oh-my-zsh/themes/
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="sunaku-minimal"/' $HOME/.zshrc
echo source $DOTREPO/.zshrc >> $HOME/.zshrc
echo source $DOTREPO/.vimrc >> $HOME/.vimrc
