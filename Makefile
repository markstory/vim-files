# Installs extensions and compiles things that need compiling.
#
#
help:
	@echo "install - install + compile native things."
	@echo "update  - Download update for all plugins."

install: symlink submodules fzf ag

submodules:
	git submodule init
	git submodule update

fzf:
	-brew install fzf

ag:
	-brew install the_silver_searcher

update:
	git submodule foreach git pull origin master

symlink:
	ln -sf ~+/vimrc ~/.vimrc
	ln -sf ~+/gvimrc ~/.gvimrc
	# Create neovim config
	mkdir -p ~/.config
	ln -sf ~+ ~/.config/nvim/
	ln -sf ~+/vimrc ~/.config/nvim/init.vim
