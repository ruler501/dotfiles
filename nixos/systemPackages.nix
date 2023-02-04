{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ark  # GUI archive management
    pkgs.awscli2
    pkgs.bear  # CMake wrapper for generating compile_commands.json for language servers.
    pkgs.chromium
    pkgs.cockatrice
    pkgs.dconf
    pkgs.delta
    pkgs.direnv
    pkgs.discord
    pkgs.etcher
    pkgs.firefox
    pkgs.fortune
    pkgs.fzy
    pkgs.gamemode
    pkgs.gdb
    pkgs.git
    pkgs.git-filter-repo
    pkgs.git-latexdiff
    pkgs.gimp
    pkgs.glances
    pkgs.gnome.gnome-system-monitor
    pkgs.gnupg
    (pkgs.google-cloud-sdk.withExtraComponents ([pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]))
    pkgs.google-chrome
    pkgs.gparted
    pkgs.graphviz
    pkgs.htop
    pkgs.imagemagick
    pkgs.nodePackages.vscode-langservers-extracted
    pkgs.jq
    pkgs.killall
    pkgs.kubectl
    pkgs.kustomize
    pkgs.lldb
    pkgs.lm_sensors
    pkgs.lsd
    pkgs.lshw
    pkgs.lsof
    pkgs.neovim-remote
    pkgs.nix-direnv
    pkgs.nix-du
    pkgs.nix-index
    pkgs.nvtop
    pkgs.obsidian
    pkgs.parallel
    pkgs.pavucontrol
    pkgs.pciutils  # Provides lspci
    pkgs.postman
    pkgs.python310Full
    pkgs.p7zip
    pkgs.ripgrep-all
    pkgs.sad
    pkgs.simplescreenrecorder
    pkgs.sloccount
    pkgs.teams
    pkgs.texstudio
    pkgs.usbutils  # Provides lsusb
    pkgs.velero
    pkgs.vlc
    pkgs.wget
    pkgs.zsh
  ];
}
