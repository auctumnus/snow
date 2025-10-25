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
                  inherit nickname;
                  server = "chat.remexre.com";
                  port = 6666;
                  channels = [ ];
                  sasl.plain = {
                    username = "autumn";
                    password_command = nick_password_command;
                  };
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
