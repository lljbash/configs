hello:
	@echo 'Hello there.'

bootstrap: install-zsh-configs-with-conda install-nvim-configs install-tmux-configs install-inputrc

reset-bootstrap:
	conda remove --name app --all
	rm -rf ${HOME}/download/nvim-linux64
	rm -rf ${HOME}/download/typos-vscode
	rm -rf ~/.zshrc ~/.zshenv ~/.zinit
	rm -rf ~/.config/nvim
	rm -rf ~/.tmux.conf ~/.tmux
	rm -rf ~/.inputrc

conda-install-missing-apps:
	conda env update -f app.yaml -p ${HOME}/.conda/envs/app --prune

update-nvim-stable:
	mkdir -p ${HOME}/download
	cd ${HOME}/download && \
	wget https://github.com/neovim/neovim-releases/releases/download/stable/nvim-linux64.tar.gz && \
	tar xzvf nvim-linux64.tar.gz && \
	rm nvim-linux64.tar.gz

update-nvim-nightly:
	mkdir -p ${HOME}/download
	cd ${HOME}/download && \
	wget https://github.com/neovim/neovim-releases/releases/download/nightly/nvim-linux64.tar.gz && \
	tar xzvf nvim-linux64.tar.gz && \
	rm nvim-linux64.tar.gz

build-typos-lsp:
	WORKDIR=${HOME}/download/typos-vscode && \
	rm -rf ${WORKDIR} && \
	git clone https://github.com/tekumara/typos-vscode ${WORKDIR} && \
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	cd ${WORKDIR} && cargo build --release

build-tree-sitter:
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	cargo install tree-sitter-cli

download-prebuilt-utils:
	WORKDIR=${HOME}/download/linux_binaries && \
	rm -rf ${WORKDIR} && \
	git clone https://github.com/lljbash/linux_binaries ${WORKDIR}

install-zsh-configs-with-conda: conda-install-missing-apps update-nvim-stable build-typos-lsp build-tree-sitter download-prebuilt-utils
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

install-miniconda:
	mkdir -p ~/miniconda3
	wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda3/miniconda.sh
	bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
	rm -rf ~/miniconda3/miniconda.sh

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
