{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.snow.zed;
in
{
  options.snow.zed.enable = lib.mkEnableOption "zed";

  config = lib.mkIf cfg.enable {

    home-manager.sharedModules = [
      {
        programs.zed-editor = {
          enable = true;
          extensions = [
            "github-theme"
            "nix"
          ];
          userSettings = {
            buffer_font_family = "Berkeley Mono";
            buffer_font_size = 15;
            ui_font_size = 16;

            vim_mode = false;
            telemetry = {
              diagnostics = true;
              metrics = false;
            };
            theme = {
              mode = "system";
              light = "GitHub Light";
              dark = "GitHub Dark";
            };
            features = {
              edit_prediction_provider = "copilot";
            };
            languages = {
              "HTML".format_on_save = "off";
            };
          };
        };
      }
    ];
  };
}
