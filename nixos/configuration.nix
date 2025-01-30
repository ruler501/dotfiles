{ hostname, pkgs, secrets, nixpkgs-stable, colors, config, nonicons, ... }: {
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
      # includeAllModules = true; # Doesn't work with stylix
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
      EDITOR = "nvr --remote-wait";
      GIT_EDITOR = "nvr --remote-wait";
      NVR_CMD = "vim";
      PNPM_HOME = "/home/devon/.npm-global/bin";
      USE_GKE_GCLOUD_AUTH_PLUGIN = "True";
      VISUAL = "nvr --remote-wait";
      XDG_DATA_HOME = "$HOME/.local/share";
    };
  };
  fonts = {
    fontconfig = {
      antialias = true;
    };
    packages = [
      "${nonicons}/dist/"
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
    # package = pkgs.nixUnstable;
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
    displayManager = {
      autoLogin.enable = false;
      defaultSession = "plasma";
      sddm = {
        enable = true;
        enableHidpi = true;
      };
    };
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
      enableJIT = true;
      ensureDatabases = [ "mydatabase" "devon" ];
      ensureUsers = [
        {
          name = "devon";
          ensureClauses = {
            createdb = true;
            createrole = true;
            login = true;
            superuser = true;
          };
          ensureDBOwnership = true;
        }
      ];
      authentication = pkgs.lib.mkOverride 10 ''
        #type database  DBuser  auth-method
        local all       all     trust
        # ipv4
        host  all      all     127.0.0.1/32   trust
        # ipv6
        host all       all     ::1/128        trust
      '';
    };
    redis = {
      servers = {
        local-redis = {
          bind = "127.0.0.1";
          enable = true;
          port = 6379;
          requirePass = "localpassword";
          save = [];
        };
      };
    };
    timesyncd.enable = true;
    uptimed.enable = true;
    xserver = {
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
  stylix = {
    autoEnable = true;
    base16Scheme = colors.base16;
    cursor = {
      package = pkgs.qogir-icon-theme;
      name = "Qogir";
    };
    fonts = {
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      # Can't remember what nonicons was for or if I need to do something for it here
      monospace = {
        package = (pkgs.nerdfonts.override { fonts = ["DroidSansMono"]; });
        name = "DroidSansMono";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 10;
        terminal = 10;
      };
    };
    homeManagerIntegration = {
      autoImport = true;
      followSystem = true;
    };
    image = config.lib.stylix.pixel "base02";
    polarity = "dark";
  };
  users = {
    defaultUserShell = pkgs.zsh;
    groups = {
      devon = { gid = 5001; members = [ "devon"]; };
    };
    mutableUsers = false;
    users = {
      devon = {
        extraGroups = ["wheel" "networkmanager" "adbusers" "docker" "audio" "kvm"];
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
