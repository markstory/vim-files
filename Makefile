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
	ln -sf ~/.vim/init.vim ~/.vimrc
	ln -sf ~/.vim/gvimrc ~/.gvimrc
	# Create neovim config
	ln -s ~/.vim ~/.config/nvim
