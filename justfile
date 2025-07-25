hello:
	@echo 'Hello there.'

bootstrap-root: ubuntu-install-apps

check-apps:
	bash ./check_apps.sh || (echo 'maybe run "make bootstrap-root"' && false)

bootstrap: check-apps install-user-apps install-zsh-configs install-nvim-configs install-tmux-configs install-inputrc

reset-bootstrap:
	sed -i "/dandavison---delta\/gitconfig/d" ~/.gitconfig
	uv cache clean
	rm -rf "$(uv python dir)"
	rm -rf "$(uv tool dir)"
	rm -rf ~/.zshrc ~/.zshenv ~/.zinit
	rm -rf ~/.config/nvim ~/.local/share/nvim
	rm -rf ~/.tmux.conf ~/.tmux
	rm -rf ~/.local
	rm -rf ~/.rustup ~/.cargo
	rm -rf ~/.nvm ~/.npm

update: install-user-apps install-nvim-configs
	cp zshrc ~/.zshrc
	zsh -ic "zinit self-update && zinit update"
	nvim --headless "+Lazy! sync" +qa
	cp tmux.conf ~/.tmux.conf
	tmux new-session -s "InstallTmuxPlugins" "sleep 1; ~/.tmux/plugins/tpm/bin/install_plugins && ~/.tmux/plugins/tpm/bin/update_plugins all || sleep 10" ||\
	  (~/.tmux/plugins/tpm/bin/install_plugins && ~/.tmux/plugins/tpm/bin/update_plugins all)

ubuntu-install-apps:
	sudo apt update
	sudo apt install -y curl wget git tar gzip zip iproute2 \
	                    zsh tmux ncurses-term \
	                    xsel fzf \
	                    gcc g++ cmake ccache universal-ctags ninja-build \
	                    sqlite3 libsqlite3-dev

install-user-apps:
	command -v uv || (curl -LsSf https://astral.sh/uv/install.sh | sh)
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
	~/.cargo/bin/rustup default stable
	~/.cargo/bin/rustup component add rust-analyzer
	~/.cargo/bin/rustup component add rust-src
	./install_node.sh

install-zsh-configs:
	cp zshrc ~/.zshrc
	cp zshenv ~/.zshenv

install-nvim-configs:
	mkdir -p ~/.config/nvim
	cd ~/.config/nvim && ~/.local/bin/uv venv --python=3.12 --python-preference="only-managed" && ~/.local/bin/uv pip install neovim
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

git-config-lljbash:
	git config --global user.name "lljbash"
	git config --global user.email "lljbash@gmail.com"

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
