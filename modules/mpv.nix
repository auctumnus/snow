{ lib, config, ... }:
let
  cfg = config.snow.mpv;
in
{
  options.snow.mpv.enable = lib.mkEnableOption "mpv";
  config = {
    home-manager.sharedModules = [
      {
        programs.mpv = lib.mkIf cfg.enable {
          enable = true;
          config = {
            hwdec = true;
          };
        };
      }
    ];
  };
}
