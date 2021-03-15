eval "$(ssh-agent -s)" > /dev/null 2>&1
alias clip='xsel -ib'

#Check version and update
if ! ["$(cat $DOTREPO/version)" == "$(wget -O- https://raw.githubusercontent.com/classy-crustacean/.dotfiles/main/version)" ] ; then
	echo -n "update dotfiles? (y/n)"
	old_stty_cfg=$(stty -g)
	stty raw -echo
	answer=$( while ! head -c 1 | grep -i '[ny]' ;do true ;done )
	stty $old_stty_cfg
	if echo "$answer" | grep -iq "^y" ;then
		git -C $DOTREPO pull
		vim -c ":PlugInstall | quit | quit"
	fi
fi
