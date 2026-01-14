{
  config,
  lib,
  ...
}:
let
  cfg = config.snow.steam;
in
{
  options.snow.steam.enable = lib.mkEnableOption "steam";
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
    };
    hardware.xone.enable = true;
  };
}
