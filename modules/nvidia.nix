# Enables Nvidia drivers, assuming you have a Turing or newer card.
{ config, lib, ... }:
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
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };
}
