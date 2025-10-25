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
    kernelPackages = pkgs.linuxKernel.packages.linux_6_12;
    loader = {
      efi.canTouchEfiVariables = true;
    };

    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 188;
    };
  };

  networking.hostId = "64656572"; # deer

  snow = {
    shell.enable = true;
    gnome.enable = true;
    graphical.enable = true;
    nvidia.enable = true;
    claude.enable = true;
    podman.enable = true;
    halloy.enable = true;
  };

  time.timeZone = "America/Chicago";

  system.stateVersion = "25.05";

  services = {
    fwupd.enable = true;
    thermald.enable = true;
    upower.enable = true;
    printing.enable = true;
    colord.enable = true;
    pipewire.wireplumber = {
      enable = true;
      extraConfig."10-disable-camera"."wireplumber.profiles".main."monitor.libcamera" = "disabled";
    };
    gvfs.enable = true;
    tumbler.enable = true;
    psd.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_lavd";
      package = pkgs.scx.rustscheds;
    };
  };

  environment.systemPackages = with pkgs; [
    signal-desktop
  ];

  home-manager.sharedModules = [
    {
      home.stateVersion = "24.05";
    }
  ];
}
