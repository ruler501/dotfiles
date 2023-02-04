1. Install the following programs (see specific distro for names)
   - gnupg
   - git
   - nerd-fonts-complete-mono-glyphs (or a complete nerd fonts with non-mono fonts as well)
   - nvm
   - lsd
   - fortune-mod
   - lolcate
   - cowsay
   - neovim
   - pyenv
   - yarn
   - wget
   - htop
   - curl
   - gnome-terminal
   - aws-cli-v2
   - git-lfs
   - diff-so-fancy
2. Setup GPG and SSH keys
   1. Symlink to files in `.gnupg` from files in `~/.gnupg` with the same name
      - `ln -s <path_to_dotfiles>/<path_to_file> <link_location>`
   2) Add a 4096 bit RSA key with `gnupg --full-generate-key --expert` and customize the capabilities to include Authentication.
   3) Run `gpg --list-secret-keys --with-keygrip --keyid-format LONG` and find the key you just created.
      1) The `sec` line will contain the key ID as `rsa4096/<keyid>`. It will also contain the keygrid clearly marked.
      2) Now run `gpg --armor --export <keyid>` to get the public key to add to github as a GPG key.
      3) Then run `gpg --export-ssh-key <keyid>` to get the public ssh key to add to github as an SSH key.
      4) Create `~/.gnupg/sshcontrol` with the keygrip as its contents such as `echo <keygrid> > ~/.gnupg/sshcontrol`.
      5) Add your keyid to a git config file under the `user` section and key `signingkey` and save it as `~/.gnupg/.git-userconfig`
3.  Symlink to `.gitconfig` from `~/.gitconfig` 
4.  Setup Neovim
    1) Install Vim-Plug with `curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`
    2) Symlink to `.nvimrc` from `~/.config/nvim/init.vim`
    3) Symlink to `darkviolet.vim` from `~/.config/nvim/colors/darkviolet.vim`.
    4) Symlink to `coc-settings.json` from `~/.config/nvim/coc-settings.json`.
    5) Open Neovim with `nvim` and run `:PlugInstall` and `:UpdateRemotePlugins`
5.  Install Python 3.8.8 with `pyenv install 3.8.8 && pyenv global 3.8.8 && pip install --user --upgrade pip`.
6.  Setup NodeJS
    1) Install nvr with `pip install --user pynvim neovim-remote`
    2) Install NodeJS 12 and 15 with `nvm install 12 && nvm install 15`
    3) Install Typescript with `npm install -g typescript`. You will likely want to install several other language servers as well.
7.  Setup ZSH
    1) If you didn't set the login shell as zsh when creating the user account run `chsh -s /bin/zsh devon`
    2) Install oh-my-zsh with `sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
    3) Install Powerlevel10k for oh-my-zsh `git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k`
    4) Symlink to `.p10k.zsh` from `~/.p10k.zsh`
    5) Symlink to `.zshrc` from `~/.zshrc`
8. Import the Gnome terminal settings with `dconf load /org/gnome/terminal/ < gnome-terminal.dconf`
9. Exit and launch gnome-terminal.
