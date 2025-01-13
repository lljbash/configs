hello:
	@echo 'Hello there.'

bootstrap-root: ubuntu-install-apps install-nvim-globally

check-apps:
	bash ./check_apps.sh || (echo 'maybe run "make bootstrap-root" or "make install-miniconda" first' && false)

bootstrap: check-apps prepare-rust install-zsh-configs install-nvim-configs install-tmux-configs install-inputrc

reset-bootstrap:
	rm -rf ~/.zshrc ~/.zshenv ~/.zinit
	rm -rf ~/.config/nvim ~/.local/share/nvim
	rm -rf ~/.tmux.conf ~/.tmux
	rm -rf ~/.rustup ~/.cargo ~/.npm
	rm -rf ~/.inputrc
	rm -rf ~/.p10k.zsh

ubuntu-install-apps:
	sudo apt update
	sudo apt install -y curl wget git snapd tar gzip zip \
	                    zsh tmux ncurses-term \
	                    xsel fzf \
	                    gcc g++ cmake ccache universal-ctags ninja-build \
	                    sqlite3 libsqlite3-dev
	sudo snap install rustup --classic
	sudo snap install node --classic

install-nvim-globally:
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
	sudo rm -rf /opt/nvim
	sudo tar -C /opt -xzf nvim-linux64.tar.gz
	rm nvim-linux64.tar.gz

prepare-rust:
	rustup default stable
	rustup component add rust-analyzer
	rustup component add rust-src

install-zsh-configs:
	cp zshrc ~/.zshrc
	cp zshenv ~/.zshenv
	command -v conda > /dev/null && conda init zsh


install-nvim-configs:
	pip install pynvim neovim debugpy --user --upgrade
	mkdir -p ~/.config/nvim
	cp -r nvim ~/.config

install-tmux-configs:
	cp tmux.conf ~/.tmux.conf
	rm -rf ~/.tmux/plugins/tpm
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
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
	~/miniconda3/bin/conda init

# NOTE: below scripts are deprecated

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
	rm -rf ${HOME}/download/typos-vscode && \
	git clone https://github.com/tekumara/typos-vscode ${HOME}/download/typos-vscode && \
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	cd ${HOME}/download/typos-vscode && cargo build --release

build-tree-sitter:
	export PATH="${HOME}/.conda/envs/app/bin:${PATH}" && \
	cargo install tree-sitter-cli

download-prebuilt-utils:
	rm -rf ${HOME}/download/linux_binaries && \
	git clone https://github.com/lljbash/linux_binaries ${HOME}/download/linux_binaries

install-zsh-configs-with-conda: conda-install-missing-apps update-nvim-stable build-typos-lsp build-tree-sitter download-prebuilt-utils
	cp legacy/zshrc-conda ~/.zshrc
	cp legacy/zshenv-conda ~/.zshenv
	conda init zsh

install-zsh-configs-ghr:
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
