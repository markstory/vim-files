# Installs extensions and compiles things that need compiling.
#
help:
	@echo "install - install + compile native things."

install: symlink deps

deps:
	-brew install fzf
	-brew install the_silver_searcher
	-brew install bat


symlink:
	ln -sf ~+/vimrc ~/.vimrc
	ln -sf ~+/gvimrc ~/.gvimrc
	# Create neovim config
	mkdir -p ~/.config
	ln -sf ~+ ~/.config/nvim
	ln -sf ~+/vimrc ~/.config/nvim/init.vim
