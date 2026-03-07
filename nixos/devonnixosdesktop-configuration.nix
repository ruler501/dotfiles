{ config, pkgs, nixpkgs-stable, modulesPath, system, ... }:
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
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      grub = {
        extraEntries = ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root 825A-E484
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
  };
  environment = {
    systemPackages = [
      nixpkgs-stable.nvtop
    ];
    variables = {
      LIBVA_DRIVER_NAME = "vdpau";
    };
  };
  fileSystems = {
    "/mnt/Share" = {
      device = "/dev/disk/by-label/Share";
      fsType = "ntfs";
    };
    "/mnt/Games" = {
      device = "/dev/disk/by-label/Games";
      fsType = "ntfs";
    };
    "/mnt/Windows" = {
      device = "/dev/disk/by-uuid/C8EE9F1AEE9EFFBC";
      fsType = "ntfs";
    };
    "/mnt/DriveA" = {
      device = "/dev/disk/by-uuid/64639E0D24875EB7";
      fsType = "ntfs";
    };
    "/mnt/NVME" = {
      device = "/dev/disk/by-uuid/14dcd0b7-2201-4be3-bc6f-053c572457cb";
      fsType = "ext4";
      options = ext4SsdOptions;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/825A-E484";
      fsType = "vfat";
    };
    "/" = {
      device = "/dev/disk/by-uuid/36aeaea9-8943-4e8c-b36b-b5d2cb31e9ea";
      fsType = "ext4";
      options = ext4SsdOptions;
    };
  };
  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    graphics = {
      extraPackages = [
        pkgs.libvdpau-va-gl
        pkgs.libva-vdpau-driver
      ];
    };
    steam-hardware.enable = true;
  };
  networking = {
    networkmanager.enable = false;
    interfaces = {
      enp6s0.useDHCP = true;
    };
    wireless.enable = false;
  };
  nix.settings = {
    cores = 32;
    max-jobs = 32;
  };
  nixpkgs.hostPlatform = system;
  programs = {
    steam.enable = true;
  };
  services = {
    xserver = {
      dpi = 100;
      videoDrivers = ["nvidia"];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/8774da94-3123-4919-9914-041a3e00cbf1"; }
  ];
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
  virtualisation = {
    docker = {
      enableNvidia = true;
    };
  };
}
