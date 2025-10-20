{ config, lib, ... }:
let
  cfg = config.snow.ghostty;
in
{
  options.snow.ghostty.enable = lib.mkEnableOption "ghostty";

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.ghostty = {
          enable = true;
          enableFishIntegration = true;
          settings = {
            theme = "dark:GitHub Dark,light:GitHub Light Default";
          };
        };
      }
    ];
  };
}
