hello:
	@echo 'Hello there.'

install-zsh-configs:
	command -v git || sudo apt-get install git
	command -v svn || sudo apt-get install subversion
	cp zshrc ~/.zshrc
	cp zshenv ~/.zshenv

install-vim-configs:
	cp vimrc ~/.vimrc

install-coc-configs:
	./install_coc_config.sh
	./install_coc_extensions.sh

install-tmux-configs:
	cp tmux.conf ~/.tmux.conf
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

install-inputrc:
	cp inputrc ~/.inputrc

install-gdbdashboard:
	wget -P ~ git.io/.gdbinit

get-llvm:
	sudo bash -c "$(wget -O - https://apt.llvm.org/llvm.sh)"

get-nodejs-12:
	curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
	sudo apt-get update
	sudo apt-get install nodejs

set-login-shell:
	cat /etc/shells
	chsh

generate-ssh-key:
	ssh-keygen -t rsa -b 4096
