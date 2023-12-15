hello:
	@echo 'Hello there.'

bootstrap: install-zsh-configs-with-conda install-nvim-configs install-tmux-configs install-inputrc

reset-bootstrap:
	conda remove --name app --all
	rm -rf ${HOME}/download/nvim-linux64
	rm -rf ~/.zshrc ~/.zshenv ~/.zinit
	rm -rf ~/.config/nvim
	rm -rf ~/.tmux.conf ~/.tmux
	rm -rf ~/.inputrc

conda-install-missing-apps:
	conda env update -f app.yaml -p ${HOME}/.conda/envs/app --prune

update-nvim-nightly:
	mkdir -p ${HOME}/download
	cd ${HOME}/download && \
	wget https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.tar.gz && \
	tar xzvf nvim-linux64.tar.gz && \
	rm nvim-linux64.tar.gz

build-typos-lsp:
	rm -rf ${HOME}/download/typos-vscode
	git clone https://github.com/tekumara/typos-vscode ${HOME}/download/typos-vscode
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	cd ${HOME}/download/typos-vscode && \
	cargo build --release

install-zsh-configs-with-conda: conda-install-missing-apps update-nvim-nightly build-typos-lsp
	cp zshrc-no-ghr ~/.zshrc
	cp zshenv ~/.zshenv
	conda init zsh

install-nvim-configs:
	mkdir -p ~/.config/nvim
	cp -r nvim ~/.config

install-tmux-configs:
	cp tmux.conf ~/.tmux.conf
	/usr/bin/tic -x tmux-256color
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	tmux new-session -s "InstallTmuxPlugins" "sleep 1; ~/.tmux/plugins/tpm/bin/install_plugins || sleep 10"

install-inputrc:
	cp inputrc ~/.inputrc

install-gdbdashboard:
	wget -P ~ git.io/.gdbinit

set-login-shell:
	cat /etc/shells
	chsh

generate-ssh-key:
	ssh-keygen -t rsa -b 4096

# NOTE: below scripts are deprecated

install-zsh-configs:
	command -v git || sudo apt-get install git
	cp legacy/zshrc ~/.zshrc
	cp legacy/zshenv ~/.zshenv

install-vim-configs:
	cp legacy/vimrc ~/.vimrc
	mkdir -p ~/.vim
	cp legacy/coc-settings.json ~/.vim/coc-settings.json

install-coc-extensions:
	legacy/install_coc_extensions.sh

link-nvim-configs:
	mkdir -p ~/.config/nvim
	ln -s ${HOME}/.vimrc ~/.config/nvim/init.vim
	ln -s ${HOME}/.vim/coc-settings.json ~/.config/nvim/coc-settings.json
