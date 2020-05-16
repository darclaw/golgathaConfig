# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [ <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

 # boot.initrd.availableKernelModules = [ "ahci" "isci" "usbhid" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" "v4l2loopback"]; # "nvidia" ];
  boot.extraModulePackages = [ ];

  boot.initrd.availableKernelModules = [ "ehci_pci" "ahci" "xhci_pci" "isci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
  #boot.kernelModules = [ "kvm-intel" ];


  fileSystems."/" =
    { device = "/dev/disk/by-uuid/d3d93bc9-f893-45b0-a976-55249c95ca50";
      fsType = "ext4";
    };
  fileSystems."/tmp" = {
    fsType = "tmpfs";
    device = "tmpfs";
    };
  #fileSystems."/boot/efi" =
  #  { device = "/dev/disk/by-uuid/76c07e40-4b8c-452e-a8d1-3b780f858544";
  #    fsType = "ext4";
  #  };

  #swapDevices =
  #  [ { device = "/dev/disk/by-uuid/6a23dae3-153f-4746-b055-9b244f6d89d7"; }
  #  ];

  nix.maxJobs = lib.mkDefault 32;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  #hardware.nvidia.modesetting = true;
}
