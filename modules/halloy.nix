{
  config,
  lib,
  pkgs,
  username,
  ...
}:
let
  cfg = config.snow.halloy;
in
{
  options.snow.halloy.enable = lib.mkEnableOption "halloy";

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.halloy = {
          enable = true;
          settings = {
            theme = {
              light = "ferra-light";
              dark = "ferra-dark";
            };
            servers =
              let
                nickname = username;
                nick_password_command = "${pkgs.zenity}/bin/zenity --password";
              in
              {
                remexre = {
                  inherit nickname nick_password_command;
                  server = "chat.remexre.com";
                  username = "autumn@hickory";
                  port = 6666;
                  channels = [ ];
                };
              };
            "buffer.channel.topic" = {
              enabled = true;
            };
          };
          themes = {
            ferra-dark = pkgs.lib.importTOML ../resources/ferra-dark.toml;
            ferra-light = pkgs.lib.importTOML ../resources/ferra-light.toml;
          };
        };
      }
    ];
  };
}
