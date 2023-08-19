# Install nvim - download binary on windows, install nightly off brew, etc -
# these seem to change a lot
# Install Source Code Pro - seems to support Powerline just fine, and looks
# slightly better than Source Code Pro for Powerline

# Install alacritty
# Install glrnvim
# ln -s ~/VimConfig/_nvimrc ~/.config/nvim/init.vim

# glrnvim - confirm exact folder by starting glrnvim -h, since readme is wrong
mkdir -p ~/Library/Preferences/glrnvim
# ln -s ~/VimConfig/glrnvim.yml ~/Library/Preferences/glrnvim/config.yml
ln -s ~/VimConfig/glrnvim.yml ~/Library/Application\ Support/glrnvim/config.yml
ln -s ~/VimConfig/alacritty.yml ~/.config/alacritty/alacritty.yml

ln -s ~/nvim-macos/bin/nvim ~/bin/nvim
ln -s ~/glrnvim/target/release/glrnvim ~/bin/lgv
