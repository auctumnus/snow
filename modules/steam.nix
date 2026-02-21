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
    programs = {
      steam = {
        enable = true;
        gamescopeSession = {
          enable = true;
        };
      };
      gamescope = {
        enable = true;
      };
    };
    hardware.xone.enable = true;
  };
}
