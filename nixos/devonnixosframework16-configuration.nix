{ pkgs, modulesPath, system, lib, nixos-hardware, nixpkgs-stable, ... }:
let
  ext4SsdOptions = [
    "data=ordered"      # Ensures data ordering, improving file system reliability and performance by writing data to disk in a specific order.
    "defaults"          # Applies the default options for mounting, which usually include common settings for permissions, ownership, and read/write access.
    "discard"           # Enables the TRIM command, which allows the file system to notify the storage device of unused blocks, improving performance and longevity of solid-state drives (SSDs).
    "errors=remount-ro" # Remounts the file system as read-only (ro) in case of errors to prevent further potential data corruption.
  ];
  rocmLibPath = lib.makeLibraryPath [ pkgs.libdrm ];

  rocmSmi = pkgs.writeShellScriptBin "rocm-smi" ''
    export LD_LIBRARY_PATH="${rocmLibPath}''${LD_LIBRARY_PATH:+:}''${LD_LIBRARY_PATH:-}"
    exec ${pkgs.rocmPackages.rocm-smi}/bin/rocm-smi "$@"
  '';

  rocmEnv = pkgs.symlinkJoin {
    name = "rocm-combined";
    paths = with pkgs.rocmPackages; [
      rocblas
      hipblas
      clr
    ];
  };
  stablePkgs = nixpkgs-stable;
in
{
  imports = [ 
    (modulesPath + "/installer/scan/not-detected.nix")
    nixos-hardware.nixosModules.framework-16-7040-amd
  ];

  boot = {
    # extraModulePackages = [ linuxPackages.zenergy ];
    # kernelModules = [ "zenergy" "msr" ];
    # kernelPackages = linuxPackages;
    kernelParams = [ "amdgpu.abmlevel=0" ];
  };
  environment = {
    systemPackages = [
      pkgs.amdgpu_top
      pkgs.clinfo
      pkgs.corectrl
      pkgs.gamescope
      pkgs.gpu-viewer
      pkgs.gpuvis
      pkgs.hidapi
      pkgs.lm_sensors
      pkgs.nvtopPackages.amd
      pkgs.powertop
      pkgs.radeon-profile
      pkgs.radeontools
      pkgs.radeontop
      pkgs.rgp
      pkgs.rocmPackages.rocminfo
      rocmSmi
      pkgs.tuxclocker
      pkgs.tuxclocker-plugins-with-unfree
      pkgs.umr
      pkgs.xpad
    ];
    variables = {
      GAMEMODERUNEXEC="env DRI_PRIME=1!";
    };
  };
  fileSystems = {
    "/" ={
      device = "/dev/disk/by-uuid/71539a24-ea83-41bd-adb7-045846ae9965";
      fsType = "ext4";
      options = ext4SsdOptions;
    };
    "/boot" ={
      device = "/dev/disk/by-uuid/7AE4-B533";
      fsType = "vfat";
    };
    "/home" = {
      device = "/dev/disk/by-uuid/7c3c61ed-9b8d-4735-a91a-c9449182b954";
      fsType = "ext4";
      options = ext4SsdOptions;
    };
  };
  hardware = {
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      overdrive = {
        enable = true;
        ppfeaturemask = "0xffffffff";
      };
      # zluda.enable = true;
    };
    bluetooth = {
      enable = true;
      package = pkgs.bluez;
      powerOnBoot = true;
    };
    cpu.amd.updateMicrocode = true;
    enableAllFirmware = true;
    graphics = {
      enable32Bit = true;
      extraPackages = [
      ];
      extraPackages32 = [
      ];
    };
  };
  networking = {
    useNetworkd = true;
    networkmanager = {
      enable = true;
    };
  };
  nix.settings = {
    cores = 16;
    max-jobs = 8;
  };
  nixpkgs.hostPlatform = system;
  programs = {
    gamemode = {
      enable = true;
      enableRenice = true;
      settings = {
        general = {
          renice = 10;
        };
      
        # Warning: GPU optimisations have the potential to damage hardware
        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };
      };
    };
    steam = {
      enable = true;
      # extest.enable = true;
      gamescopeSession.enable = true;
      # package = stablePkgs.steam;
    };
  };
  services = {
    blueman.enable = true;
    udisks2.enable = true;
    thermald.enable = true;
    gvfs.enable = true;
    lact.enable = true;
    xserver.videoDrivers = [ "modesetting" ];
  };
  swapDevices =[ 
    { device = "/dev/disk/by-uuid/b2c9eac0-c8d3-4db4-9a86-6c4d4afcf12d"; }
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
  systemd = {
    network = {
      enable = true;
      wait-online = {
        enable = false;
      };
    };
    tmpfiles.rules = [
      "L+    /opt/rocm   -    -    -     -    ${rocmEnv}"
    ];
  };
}
