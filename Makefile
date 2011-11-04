# Installs extensions and compiles things that need compiling.
#
#

install: commandt

commandt:
	cd bundle/Command-T/ruby/command-t/;\
		/usr/bin/ruby extconf.rb;\
		make clean && make

