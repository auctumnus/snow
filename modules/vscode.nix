{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.snow.vscode;
in
{
  options.snow.vscode.enable = lib.mkEnableOption "vscode";

  config = lib.mkIf cfg.enable {

    home-manager.sharedModules = [
      {
        programs.vscode = {
          enable = true;
          mutableExtensionsDir = false;
          profiles.default = {
            extensions =
              with pkgs.vscode-extensions;
              [
                github.copilot
                mkhl.direnv
                github.github-vscode-theme
                mkhl.direnv
                rust-lang.rust-analyzer
                jnoortheen.nix-ide
                github.copilot-chat
              ]
              ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                  name = "live-server";
                  publisher = "ms-vscode";
                  version = "0.5.2024062701";
                  sha256 = "sha256-03UXPaoW7DpApaLFJyZRdTKfCDbXudglFC7Dwj4w8yo=";
                }
                {
                  name = "vsliveshare";
                  publisher = "MS-vsliveshare";
                  version = "1.0.5959";
                  sha256 = "sha256-MibP2zqTwlXXVsXQOSuoi5SO8BskJC/AihrhJFg8tac=";
                }
              ];
            userSettings = {
              "window.autoDetectColorScheme" = true;
              "workbench.preferredLightColorTheme" = "GitHub Light Default";
              "workbench.preferredDarkColorTheme" = "GitHub Dark Default";
              "rust-analyzer.check.command" = "clippy";
              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "${pkgs.nixd}/bin/nixd";
              "github.copilot.nextEditSuggestions.enabled" = true;
            };
          };
        };
      }
    ];
  };
}
