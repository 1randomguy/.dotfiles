#!/usr/bin/env bash

# make sure we have pulled in and updated any submodules
git submodule init
git submodule update

# install required programs
REQ="zsh stow"

echo ""
echo "Installing prerequisites"

if command -v apt > /dev/null; then
	sudo apt install $REQ
elif command -v dnf > /dev/null; then
	sudo dnf install $REQ
else
	echo "Please install $REQ manually"
fi

# all folders to include
app_configs=(
    zsh
    p10k
)

echo ""
echo "Stowing apps for user: ${whoami}"

# install apps available
for app in ${app_configs[@]}; do
    stow -v -R -t "$HOME" $app
done

if [ ! -f "$HOME/.gitconfig" ]; then
   cp git/.gitconfig $HOME
fi

# set zsh as standard shell
if [ ! $SHELL = "/bin/zsh" ]; then
	echo ""
	echo "Setting default user shell to zsh"
	chsh --shell /bin/zsh ${whoami}
fi

echo ""
echo "Done! - Reloading terminal"
exec zsh
