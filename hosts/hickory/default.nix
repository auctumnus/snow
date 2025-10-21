# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    # use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    initrd.luks.devices."luks-832f4153-f0cb-4929-9ec6-d00f64694cdd".device =
      "/dev/disk/by-uuid/832f4153-f0cb-4929-9ec6-d00f64694cdd";
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  snow = {
    gnome.enable = true;
    nvidia.enable = true;
    claude.enable = true;
    steam.enable = true;
  };

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";
}
