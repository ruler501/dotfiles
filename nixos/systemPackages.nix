{ pkgs, nixpkgs-stable, ... }@inputs:
let
  pythonPackages = pkgs.python313Packages;
  neovim-patched = import ./neovim.nix inputs;
  kdePackages = pkgs.kdePackages;
  jetbrainsPackages = pkgs.jetbrains;
in
{
  environment.systemPackages = [
    pkgs.android-studio
    pkgs.ansel
    kdePackages.ark  # GUI archive management
    pkgs.bear  # CMake wrapper for generating compile_commands.json for language servers.
    pkgs.calibre
    pkgs.chromium
    pkgs.cockatrice
    # pkgs.cockroachdb-bin
    kdePackages.colord-kde
    pkgs.darktable
    pkgs.dconf  # Backend for GSettings
    pkgs.discord
    pkgs.dnglab
    pkgs.exiftool
    pkgs.exiv2
    pkgs.firefox
    pkgs.fortune
    pkgs.fzy
    # nixpkgs-stable.gamemode # Allow games to request temporary application of optimization settings to the system when run through it.
    pkgs.gdb
    pkgs.git
    pkgs.git-latexdiff
    pkgs.gimp
    pkgs.glances
    pkgs.gmic
    pkgs.gmic-qt
    pkgs.gnome-system-monitor
    (pkgs.google-cloud-sdk.withExtraComponents ([pkgs.google-cloud-sdk.components.gke-gcloud-auth-plugin]))
    pkgs.google-chrome
    pkgs.gparted
    pkgs.gphoto2
    pkgs.gphoto2fs
    pkgs.graphviz
    pkgs.htop
    pkgs.imagemagick
    pkgs.inkscape
    jetbrainsPackages.clion
    jetbrainsPackages.webstorm
    pkgs.killall
    # pkgs.leanblueprint
    pkgs.libxkbfile
    pkgs.libreoffice
    pkgs.lldb
    pkgs.lm_sensors
    pkgs.loccount
    pkgs.lshw
    pkgs.lsof
    pkgs.monkeysphere # some weird ssl/tls auth thing
    pkgs.neovim-remote
    neovim-patched
    pkgs.nix-direnv
    pkgs.nix-du # Disk usage by gc root
    pkgs.nix-index # Search what packages have specific files
    pkgs.obsidian
    pkgs.openssl
    pkgs.parallel
    pkgs.pciutils  # Provides lspci
    pkgs.perf
    # config.boot.kernelPackages.perf
    pkgs.postman
    pythonPackages.python
    pythonPackages.pynvim
    pkgs.p7zip
    pkgs.rawtherapee
    pkgs.ripgrep-all
    pkgs.sad
    pkgs.signal-desktop
    pkgs.simplescreenrecorder
    pkgs.texstudio
    pkgs.usbutils  # Provides lsusb
    pkgs.vlc
    pkgs.wget
    pkgs.xdg-utils
    pkgs.zathura
    pkgs.zoom-us
  ];
}
