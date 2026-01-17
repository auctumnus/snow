{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.senpai;
  ping-me =
    if config.snow.graphical.enable then
      pkgs.writeScript "on-highlight" ''
        #!/usr/bin/env sh
        if [ "$SENDER" = "$BUFFER" ]; then
          title="$SENDER"
        else
          title="$SENDER ($BUFFER)"
        fi
        ${pkgs.libnotify}/bin/notify-send "$title" "$MESSAGE"
      ''
    else
      pkgs.writeScript "on-highlight" ''
        #!/usr/bin/env sh
      '';
in
{
  options.snow.senpai.enable = lib.mkEnableOption "senpai";

  config = lib.mkIf cfg.enable {
    home-manager.sharedModules = [
      {
        programs.senpai = {
          enable = true;
          config = {
            address = "irc.kmwc.org:6697";
            username = "autumn@hickory";
            nickname = "autumn";
            password-cmd = [
              "${pkgs.zenity}/bin/zenity"
              "--password"
            ];
            on-highlight-beep = true;
            on-highlight-path = "${ping-me}";
          };
        };
      }
    ];
  };
}
