{
  pkgs,
  config,
  lib,
  ...
}:
let
  pinentryPackage = if config.snow.graphical.enable then pkgs.pinentry-gnome3 else pkgs.pinentry-tty;
  cfg = config.snow.gpg;
in
{
  options.snow.gpg.enable = lib.mkEnableOption "gpg";
  config = lib.mkIf cfg.enable {
    programs = {
      gnupg.agent = {
        enable = true;
        inherit pinentryPackage;
      };
    };

    home-manager.sharedModules = [
      {
        programs.gpg.enable = true;
        services.gpg-agent = {
          enable = true;
          enableExtraSocket = true;
          pinentry.package = pinentryPackage;
        };
      }
    ];
  };
}
