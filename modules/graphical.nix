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
      zed.enable = lib.mkDefault true;
      mpv.enable = lib.mkDefault true;
      halloy.enable = lib.mkDefault true;
    };

    home-manager.sharedModules = [
      {
        home.file.".XCompose".source = ../resources/XCompose;
      }
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "qtwebengine-5.15.19"
    ];

    environment.systemPackages = with pkgs; [
      ffmpeg-headless
      ffmpegthumbnailer
      obsidian
      vesktop
      _1password-gui
      krita
      thunderbird
      zoom-us
      jellyfin-media-player
      gimp
      inkscape
      feishin
    ];

    fonts = {
      enableDefaultPackages = true;
      packages = with pkgs; [
        corefonts
        vista-fonts
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
        roboto-slab
        roboto
        roboto-serif
      ];
    };
  };
}
