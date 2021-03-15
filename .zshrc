epochtarget="259200"
eval "$(ssh-agent -s)" > /dev/null 2>&1
alias clip='xsel -ib'
#Check version and update
OLDVERSION="$(cat $DOTREPO/version)"
echo $OLDVERSION
CURRENTVERSION="$(date +"%s")"
VERSIONDIFF=$(($CURRENTVERSION - $OLDVERSION)) 
echo $VERSIONDIFF
if ! [ $VERSIONDIFF -gt $epochtarget] ; then
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
