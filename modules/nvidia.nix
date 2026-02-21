# Enables Nvidia drivers, assuming you have a Turing or newer card.
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.nvidia;
in
{
  options.snow.nvidia.enable = lib.mkEnableOption "nvidia";

  config = lib.mkIf cfg.enable {
    hardware.graphics.enable = true;
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.nvidia = {
      # Modesetting is required
      modesetting.enable = true;
      # power management is experimental
      # "enable this if you have graphical corruption issues or
      # application crashes after waking up from sleep"
      powerManagement.enable = true;
      # powerManagement.finegrained = false;
      # open source kernel module
      open = true;
      # enables the nvidia settings menu (`nvidia-settings`)
      nvidiaSettings = true;
      package =
        let
          base = config.boot.kernelPackages.nvidiaPackages.mkDriver {
            version = "590.48.01";
            sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
            openSha256 = "sha256-hECHfguzwduEfPo5pCDjWE/MjtRDhINVr4b1awFdP44=";
            settingsSha256 = "sha256-4SfCWp3swUp+x+4cuIZ7SA5H7/NoizqgPJ6S9fm90fA=";
            persistencedSha256 = "";
          };
          cachyos-nvidia-patch = pkgs.fetchpatch {
            url = "https://raw.githubusercontent.com/CachyOS/CachyOS-PKGBUILDS/master/nvidia/nvidia-utils/kernel-6.19.patch";
            sha256 = "sha256-YuJjSUXE6jYSuZySYGnWSNG5sfVei7vvxDcHx3K+IN4=";
          };

          # Patch the appropriate driver based on config.hardware.nvidia.open
          driverAttr = if config.hardware.nvidia.open then "open" else "bin";
        in
        base
        // {
          ${driverAttr} = base.${driverAttr}.overrideAttrs (oldAttrs: {
            patches = (oldAttrs.patches or [ ]) ++ [ cachyos-nvidia-patch ];
          });
        };
    };
  };
}
