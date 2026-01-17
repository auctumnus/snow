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
            font-family = "Berkeley Mono Variable";
            font-variation = "wdth=90";
            font-size = 13;
            theme = "dark:GitHub Dark,light:GitHub Light Default";
            #font-features = "calt, liga, dlig";
            shell-integration-features = "ssh-env";
          };
        };
      }
    ];
  };
}
