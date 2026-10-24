{ pkgs, nixpkgs-stable, ... }@inputs:
let
  pythonPackages = pkgs.python313Packages;
  neovim-patched = import ./neovim.nix inputs;
  kdePackages = pkgs.kdePackages;
  jetbrainsPackages = pkgs.jetbrains;
  stablePkgs = nixpkgs-stable;
in
{
  environment.systemPackages = [
    pkgs.android-studio
    pkgs.ansel
    kdePackages.ark  # GUI archive management
    pkgs.bear  # CMake wrapper for generating compile_commands.json for language servers.
    pkgs.calibre
    pkgs.chromium
    jetbrainsPackages.clion
    pkgs.cockatrice
    # pkgs.cockroachdb-bin
    kdePackages.colord-kde
    pkgs.darktable
    pkgs.db
    pkgs.dconf  # Backend for GSettings
    pkgs.discord
    pkgs.dnglab
    pkgs.electrum
    pkgs.exiftool
    pkgs.exiv2
    pkgs.file
    pkgs.firefox
    pkgs.fortune
    pkgs.furmark
    pkgs.fzy
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
    pkgs.hugin
    pkgs.imagemagick
    pkgs.inkscape
    kdePackages.kfind
    pkgs.killall
    pkgs.libxkbfile
    pkgs.libreoffice
    pkgs.lldb
    pkgs.lm_sensors
    pkgs.loccount
    pkgs.lshw
    pkgs.lsof
    pkgs.mangohud
    pkgs.mesa-demos   # Adds glxinfo and other utilities 
    pkgs.monkeysphere # some weird ssl/tls auth thing
    pkgs.neovim-remote
    neovim-patched
    pkgs.nix-du # Disk usage by gc root
    pkgs.nix-index # Search what packages have specific files
    pkgs.ntfs3g
    pkgs.obsidian
    pkgs.openssl
    pkgs.parallel
    pkgs.partclone
    pkgs.partclone-utils
    pkgs.pciutils  # Provides lspci
    pkgs.perf
    # config.boot.kernelPackages.perf
    pkgs.postman
    pythonPackages.python
    pythonPackages.pynvim
    pkgs.p7zip
    pkgs.rapidraw
    stablePkgs.ratarmount
    pkgs.rawtherapee
    pkgs.rclone
    pkgs.rclone-browser
    pkgs.ripgrep-all
    pkgs.sad
    pkgs.scrounge-ntfs
    pkgs.signal-desktop
    stablePkgs.simplescreenrecorder
    pkgs.testdisk
    pkgs.testdisk-qt
    pkgs.texstudio
    pkgs.unigine-superposition
    pkgs.usbutils  # Provides lsusb
    pkgs.vlc
    pkgs.vulkan-caps-viewer
    pkgs.vulkan-tools  # vulkaninfo and other tools
    jetbrainsPackages.webstorm
    pkgs.wget
    pkgs.xdg-utils
    pkgs.zathura
    pkgs.zoom-us
  ];
}
