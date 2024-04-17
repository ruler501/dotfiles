{ hostname, pkgs, nonicons, secrets, nixpkgs-stable, ... }: {
  imports = [
    # Include system specific configurations.
    ((builtins.toString ./.) + "/" + hostname + "-configuration.nix")
  ];
  boot = {
    enableContainers = true;
    binfmt.emulatedSystems = [
      "aarch64-linux"
    ];
    hardwareScan = true;
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
      grub = {
        configurationLimit = 5;
        devices = ["nodev"];
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
    dev.enable = true;
    doc.enable = true;
    info.enable = true;
    man = {
      enable = true;
      generateCaches = true;
      man-db = {
        enable = true;
      };
    };
    nixos = {
      enable = true;
      includeAllModules = true;
      options = {
        splitBuild = true;
      };
    };
  };
  environment = {
    pathsToLink = [
      "/share/zsh"
      "/share/nix-direnv"
    ];
    shells = [pkgs.zsh];
    variables = {
      XDG_DATA_HOME = "$HOME/.local/share";
      EDITOR = "nvr --remote-wait";
      VISUAL = "nvr --remote-wait";
      GIT_EDITOR = "nvr --remote-wait";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
      PNPM_HOME = "/home/devon/.npm-global/bin";
    };
  };
  fonts = {
    fontconfig = {
      antialias = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = ["DroidSansMono" "nonicons"];
      };
    };
    packages = [
      (pkgs.nerdfonts.override { fonts = ["DroidSansMono"]; })
      "${nonicons}/dist/"
      pkgs.noto-fonts-emoji
    ];
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
      "electron-25.9.0"
    ];
  };
  programs = {
    adb.enable = true;
    command-not-found.enable = true;
    less.enable = true;
    npm.enable = false;
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
    rtkit.enable = true; # Enables processes to request real time scheduling, needed for pipewire.
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
      enable = false;
      package = nixpkgs-stable.mongodb-4_4;
      replSetName = "rs0";
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = false;
    };
    postgresql = {
      enable = true;
      ensureDatabases = [ "mydatabase" ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
    };
    timesyncd.enable = true;
    uptimed.enable = true;
    xserver = {
    displayManager = {
      autoLogin.enable = false;
      defaultSession = "plasma";
      sddm = {
        enable = true;
        enableHidpi = true;
      };
    };
      desktopManager.plasma5 = {
        enable = true;
      };
      enable = true;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
    };
  };
  sound.enable = false;
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
