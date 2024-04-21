{ pkgs, nixpkgs-stable, ... }:
let
  pythonPackages = pkgs.python311Packages;
in
{
  environment.systemPackages = [
    pkgs.ark  # GUI archive management
    pkgs.bear  # CMake wrapper for generating compile_commands.json for language servers.
    pkgs.calibre
    pkgs.chromium
    pkgs.cockatrice
    pkgs.cockroachdb-bin
    pkgs.dconf  # Backend for GSettings
    pkgs.discord
    pkgs.firefox
    pkgs.fortune
    pkgs.fzy
    nixpkgs-stable.gamemode # Allow games to request temporary application of optimization settings to the system when run through it.
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
    pkgs.inkscape
    pkgs.jetbrains.clion
    pkgs.jetbrains.webstorm
    pkgs.killall
    pkgs.libreoffice
    pkgs.lldb
    pkgs.lm_sensors
    pkgs.lshw
    pkgs.lsof
    pkgs.monkeysphere # some weird ssl/tls auth thing
    pkgs.neovim-remote
    pkgs.nix-direnv
    pkgs.nix-du # Disk usage by gc root
    pkgs.nix-index # Search what packages have specific files
    pkgs.obsidian
    pkgs.openssl
    pkgs.parallel
    pkgs.pciutils  # Provides lspci
    # pkgs.postman # Failing to download
    pythonPackages.python
    pythonPackages.pynvim
    pkgs.p7zip
    nixpkgs-stable.ripgrep-all # Fails tests on unstable
    pkgs.sad
    pkgs.simplescreenrecorder
    pkgs.sloccount
    pkgs.texlive.combined.scheme-full
    pkgs.texstudio
    pkgs.usbutils  # Provides lsusb
    pkgs.vlc
    pkgs.wget
    pkgs.xdg-utils
    pkgs.zoom-us
  ];
}
