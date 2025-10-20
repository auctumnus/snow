{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.ime;
  gnomeEnabled = config.snow.gnome.enable;
in
{
  # TODO: figure out chinese & cyrillic IMEs
  options.snow.ime.enable = lib.mkEnableOption "ime";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        i18n = {
          extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
          inputMethod = {
            enable = true;
            type = "ibus";
            ibus.engines = with pkgs.ibus-engines; [ mozc ];
          };
        };
      }
      (lib.mkIf gnomeEnabled {
        home-manager.sharedModules = [
          {
            dconf.settings."org/gnome/shell".enabled-extensions = with pkgs.gnomeExtensions; [
              kimpanel.extensionUuid
            ];
          }
        ];
        environment.systemPackages = with pkgs.gnomeExtensions; [ kimpanel ];
      })
    ]
  );
}
