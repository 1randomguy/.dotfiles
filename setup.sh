#!/usr/bin/env bash

# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# check if root
#if ! [[ ${EUID} -eq 0 ]] && [[ ${LIST_DEP} -eq 0 ]] ; then
#	  echo "Run setup script with root permissions!"
#  exit 1
#fi

# install required programs
REQ="zsh stow"

if command -v apt > /dev/null; then
	sudo apt install $REQ
elif command -v dnf > /dev/null; then
	sudo dnf install $REQ
else
	echo "Please install $REQ manually"
fi

# install font
# mkdir -p ~/.local/share/fonts
# cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/FiraCode/Regular/FiraCodeNerdFont-Regular.otf

# all folders to include
app_configs=(
    zsh
)

# run the stow command for the passed in directory ($2) in location $1
stowit() {
    usr=$1
    app=$2
    # -v verbose
    # -R recursive
    # -t target
    stow -v -R -t ${usr} ${app}
}

echo ""
echo "Stowing apps for user: ${whoami}"

# install apps available
for app in ${app_configs[@]}; do
    #stowit "${HOME}" $app 
    stow -v -R -t "$HOME" $app
done

# set zsh as standard shell
chsh --shell /bin/zsh ${whoami}

echo ""
echo "##### ALL DONE"
echo "RELOAD TERMINAL (exec zsh)"
exec zsh
