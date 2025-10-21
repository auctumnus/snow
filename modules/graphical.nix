# Common GUI programs that should be available across all DE's,
# but have no business being their own module.
# Do not add things that are DE-specific.
{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.snow.graphical;
in
{
  options.snow.graphical.enable = lib.mkEnableOption "graphical";

  config = lib.mkIf cfg.enable {
    snow = {
      firefox.enable = lib.mkDefault true;
      ghostty.enable = lib.mkDefault true;
      vscode.enable = lib.mkDefault true;
      mpv.enable = lib.mkDefault true;
      halloy.enable = lib.mkDefault true;
    };

    home-manager.sharedModules = [
      {
        home.file.".XCompose".source = ../resources/XCompose;
      }
    ];

    environment.systemPackages = with pkgs; [
      obsidian
      vesktop
      _1password-gui
      signal-desktop-bin
      krita
    ];
  };
}
