# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ hostname, config, pkgs, lib, nur, nonicons, secrets, nixpkgs-stable, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ((builtins.toString ./.) + "/" + hostname + "-configuration.nix")
  ];
  boot = {
    enableContainers = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
    blacklistedKernelModules = [];
    extraModulePackages = [];
    hardwareScan = true;
    kernelModules = [];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        configurationLimit = 5;
        devices = [ "nodev" ];
        efiSupport = true;
        enable = true;
        useOSProber = true;
      };
    };
    readOnlyNixStore = true;
  };
  console = {
    packages = [];
    colors = [];
    useXkbConfig = true;
  };
  documentation = {
    enable = true;
    # dev.enable = true;
    # doc.enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    # nixos = {
    #   enable = true;
    #   includeAllModules = true;
    # };
  };
  environment = {
    pathsToLink = [
      "/share/zsh"
      "/share/nix-direnv"
    ];
    shells = [pkgs.zsh];
    variables = {
      LIBVA_DRIVER_NAME = "vdpau";
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "nvr --remote-wait";
      VISUAL = "nvr --remote-wait";
      GIT_EDITOR = "nvr --remote-wait";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
      PNPM_HOME = "/home/devon/.npm-global/bin";
    };
    etc = {
      "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
        }
      '';
    };
  };
  fonts = {
    fonts = [
      (pkgs.nerdfonts.override { fonts = ["DroidSansMono"]; })
      "${nonicons}/dist/"
      pkgs.noto-fonts-emoji
    ];
    fontconfig = {
      antialias = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["DroidSansMono" "nonicons"];
      };
    };
  };
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
    };
    ckb-next = {
      enable = true;
      package = pkgs.ckb-next;
    };
    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
    # Required for Steam to run per this GitHub comment:
    # https://github.com/NixOS/nixpkgs/issues/47932#issuecomment-447508411
    opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
    };
    # steam-hardware.enable = true;
  };
  i18n.defaultLocale = "en_US.UTF-8";
  networking = {
    dhcpcd = {
      enable = true;
      wait = "background";
    };
    enableIPv6 = false;
    firewall.enable = true;
    hostName = hostname;
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
  };
  nix = {
    checkConfig = true;
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = ["daily"];
    };
    package = pkgs.nixUnstable;
    settings = {
      allowed-users = ["@wheel"];
      auto-optimise-store = true;
      sandbox = true;
    };
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs = true
      keep-derivations = true
    '';
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-12.2.3"
      "electron-21.4.0"
    ];
  };
  programs = {
    adb.enable = true;
    command-not-found.enable = true;
    gnome-terminal.enable = true;
    less.enable = true;
    npm.enable = false;
    # TODO: Debug why Steam seems to fail to download.
    # steam.enable = true;
    system-config-printer.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      enableGlobalCompInit = true;
      autosuggestions.enable = true;
      histSize = 65536;
      ohMyZsh.enable = true;
    };
  };
  security = {
    allowSimultaneousMultithreading = true;
    rtkit.enable = true;
  };
  services = {
    ananicy = { # Applies automatic nice values for cpu and io.
      enable = true;
    };
    arbtt = { # Automatically tracks statistics on activity on machine.
      enable = true;
      sampleRate = 60;
    };
    automatic-timezoned.enable = true;
    blueman.enable = true;
    mongodb = {
      bind_ip = "0.0.0.0";
      enable = true;
      package = nixpkgs-stable.mongodb-4_4;
      replSetName = "rs0";
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
    };
    timesyncd.enable = true;
    uptimed.enable = true;
    xserver = {
      enable = true;
      desktopManager.plasma5 = {
        enable = true;
        phononBackend = "vlc";
      };
      displayManager = {
        autoLogin.enable = false;
        defaultSession = "plasma";
        sddm = {
          enable = true;
          enableHidpi = true;
        };
      };
      layout = "us";
      xkbOptions = "ctrl:nocaps";
    };
  };
  sound.enable = false;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  users = {
    defaultUserShell = pkgs.zsh;
    groups.devon = { gid = 5001; members = [ "devon"]; };
    mutableUsers = false;
    users = {
      devon = {
        extraGroups = ["wheel" "networkmanager" "adbusers" "docker" "audio"];
        hashedPassword = secrets.hashedPassword;
        isNormalUser = true;
        uid = 5001;
      };
      root.hashedPassword = "*";
    };
  };
  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      enableNvidia = true;
      autoPrune.enable = true;
    };
  };
  xdg = {
    autostart.enable = true;
    icons.enable = true;
    menus.enable = true;
    mime.enable = true;
    sounds.enable = true;
  };
}
