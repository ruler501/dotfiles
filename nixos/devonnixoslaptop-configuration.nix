# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
    '';
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    extraModulePackages = [ ];
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      kernelModules = [ ];
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      grub = {
        extraEntries = ''
          menuentry "Windows" {
            insmod part_gpt
            insmod fat
            insmod search_fs_uuid
            insmod chain
            search --fs-uuid --set=root 2837-43C6
            chainloader /EFI/Microsoft/Boot/bootmgfw.efi
          }
        '';
      };
    };
  };
  environment.systemPackages = [
    nvidia-offload
  ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/6ae570a2-5c7f-4fbc-a047-a7ea47e31d06";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/2837-43C6";
      fsType = "vfat";
    };
    "/mnt/Share" = {
      device = "/dev/disk/by-uuid/5D90D3A8449896B7";
      fsType = "ntfs";
      options = ["defaults" "uid=5001" "gid=5001"];
    };
    "/mnt/Windows" = {
      device = "/dev/disk/by-uuid/C09E84A79E849814";
      fsType = "ntfs";
      options = ["defaults" "uid=5001" "gid=5001"];
    };
  };
  hardware = {
    cpu.intel.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      prime = {
        offload.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      powerManagement = {
        enable = true;
        finegrained = true;
      };
    };
    # high-resolution display
    video.hidpi.enable = true;
  };
  networking = {
    interfaces = {
      wlp59s0.useDHCP = true;
    };
    networkmanager.enable = true;
  };
  nix.settings = {
    cores = 16;
    max-jobs = 4;
  };
  nixpkgs.hostPlatform = "x86_64-linux";
  services = {
    power-profiles-daemon.enable = false;
    tlp = {
      enable = true;
      settings = {
        CPU_BOOST_ON_AC = "1";
        CPU_BOOST_ON_BAT = "1";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
        CPU_HWP_DYN_BOOST_ON_AC = "1";
        CPU_HWP_DYN_BOOST_ON_BAT = "1";
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        # http://smackerelofopinion.blogspot.com/2011/03/making-sense-of-pcie-aspm.html
        PCIE_ASPM_ON_AC = "default";
        PCIE_ASPM_ON_BAT = "powersave";
        RUNTIME_PM_ON_AC = "on";
        RUNTIME_PM_ON_BAT = "auto";
        SCHED_POWERSAVE_ON_AC = "0";
        SCHED_POWERSAVE_ON_BAT = "1";
        TLP_ENABLE = "1";
        TLP_WARN_LEVEL = "3";
        WOL_DISABLE="Y";
      };
    };
    xserver = {
      dpi = 150;
      videoDrivers = ["nvidia"];
    };
  };
  swapDevices = [
    { device = "/dev/disk/by-uuid/2c8a21ea-4b66-465b-ae1c-592c53e21854"; }
  ];
}
