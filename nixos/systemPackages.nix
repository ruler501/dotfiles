{ pkgs, ... }:
{
  environment.systemPackages = [
    pkgs.ark  # GUI archive management
    pkgs.awscli2
    pkgs.bear  # CMake wrapper for generating compile_commands.json for language servers.
    pkgs.chromium
    pkgs.cockatrice
    pkgs.dconf  # Backend for GSettings
    pkgs.discord
    pkgs.etcher  # Make liveUSB
    pkgs.firefox
    pkgs.fortune
    pkgs.fzy
    pkgs.gamemode # Allow games to request temporary application of optimization settings to the system when run through it.
    pkgs.gdb
    pkgs.git
    pkgs.git-latexdiff
    pkgs.gimp
    pkgs.glances
    pkgs.gnome.gnome-system-monitor
    (pkgs.google-cloud-sdk.withExtraComponents ([pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]))
    pkgs.google-chrome
    pkgs.gparted
    pkgs.graphviz
    pkgs.htop
    pkgs.imagemagick
    pkgs.killall
    pkgs.lldb
    pkgs.lm_sensors
    pkgs.lshw
    pkgs.lsof
    pkgs.neovim-remote
    pkgs.nix-direnv
    pkgs.nix-du # Disk usage by gc root
    pkgs.nix-index # Search what packages have specific files
    pkgs.nvtop
    pkgs.obsidian
    pkgs.parallel
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
    pkgs.vlc
    pkgs.wget
  ];
}
