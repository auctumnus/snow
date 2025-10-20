{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.tailscale;
  gnomeEnabled = config.snow.gnome.enable;
in
{
  options.snow.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.tailscale = {
          enable = true;
          openFirewall = true;
        };
      }
      (lib.mkIf gnomeEnabled {
        home-manager.sharedModules = [
          {
            dconf.settings."org/gnome/shell".enabled-extensions = with pkgs.gnomeExtensions; [
              tailscale-qs.extensionUuid
            ];
          }
        ];
        environment.systemPackages = with pkgs.gnomeExtensions; [ tailscale-qs ];
      })
    ]
  );
}
