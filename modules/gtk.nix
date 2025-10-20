{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.snow.gtk;
  inherit (lib) mkIf mkEnableOption;
in
{
  options.snow.gtk.enable = mkEnableOption "gtk";

  config.home-manager.sharedModules = mkIf cfg.enable [
    {
      gtk = {
        font = {
          name = "Roboto";
          package = pkgs.roboto;
          size = 16;
        };
        theme = {
          name = "adw-gtk3";
          package = pkgs.adw-gtk3;
        };
      };
    }
  ];
}
