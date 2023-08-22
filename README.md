Setup:

Install:

nodejs
cargo

-- Required for lsp
pip install neovim


Mac:

cargo install alacritty

mkdir -p ~/.config/nvim
ln -s ~/VimConfig/lua/init.lua ~/.config/nvim/init.lua

Windows:

mkdir -p %HOME%\AppData\Local\nvim
mklink %HOME%\AppData\Local\nvim\init.vim %HOME%\VimConfig\_nvimrc
