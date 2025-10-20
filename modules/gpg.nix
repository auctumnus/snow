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
      ssh.startAgent = false;
      gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
        inherit pinentryPackage;
      };
    };

    home-manager.sharedModules = [
      {
        programs.gpg.enable = true;
        services.gpg-agent = {
          enable = true;
          enableSshSupport = true;
          enableExtraSocket = true;
          pinentry.package = pinentryPackage;
        };
      }
    ];
  };
}
