{ pkgs, modulesPath, system, ... }:
let
  ext4SsdOptions = [
    "data=ordered"      # Ensures data ordering, improving file system reliability and performance by writing data to disk in a specific order.
    "defaults"          # Applies the default options for mounting, which usually include common settings for permissions, ownership, and read/write access.
    "discard"           # Enables the TRIM command, which allows the file system to notify the storage device of unused blocks, improving performance and longevity of solid-state drives (SSDs).
    "errors=remount-ro" # Remounts the file system as read-only (ro) in case of errors to prevent further potential data corruption.
  ];
in
{
  imports =[ 
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [ ];
    };
    kernelModules = [ 
      "amdgpu" 
      "kvm-amd"
    ];
    kernelParams = [
      "amdgpu.abmlevel=1"
    ];
  };
  environment.systemPackages = [
    pkgs.framework-tool
    # pkgs.nvtopPackages.amd # nvtopPackages doesn't exist on stable
  ];
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
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
    keyboard = {
      qmk = {
        enable = true;
      };
    };
    opengl = {
      extraPackages = [
        pkgs.vaapiVdpau
        pkgs.libvdpau-va-gl
        # pkgs.mangohud
        # pkgs.gamescope
        # pkgs.amdvlk
      ];
      extraPackages32 = [
        # pkgs.gamescope
      ];
    };
    sensor = {
      iio = {
        enable = true;
      };
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
    steam.enable = true;
  };
  services = {
    fprintd = {
      enable = true;
    };
    fwupd = {
      enable = true;
    };
    power-profiles-daemon = {
      enable = true;
    };
    xserver = {
      dpi = 120;
      videoDrivers = ["modesetting"];
    };
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
  };
}
