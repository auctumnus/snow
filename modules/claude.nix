{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.snow.claude;
in
{
  options.snow.claude.enable = lib.mkEnableOption "claude";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      inputs.claude-code.packages."x86_64-linux".claude-code
      # claude code in vscode requires this; TODO: can we get this to only be visible to vscode?
      nodejs_24
    ];

    programs.nix-ld = {
      enable = true;
    };

    home-manager.sharedModules = (
      if config.snow.vscode.enable then
        [
          {
            programs.vscode.profiles.default.extensions = [ pkgs.claude-vscode ];
            programs.vscode.profiles.default.userSettings = {
              claude-code.useTerminal = true;
            };
          }
        ]
      else
        [ ]
    );
  };
}
