{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.claude;
in
{
  options.snow.claude.enable = lib.mkEnableOption "claude";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      claude-code

      # claude code in vscode requires this; TODO: can we get this to only be visible to vscode?
      nodejs_24
    ];

    home-manager.sharedModules = (
      if config.snow.vscode.enable then
        [
          {
            programs.vscode.profiles.default.extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace [
              {
                name = "claude-code";
                publisher = "anthropic";
                version = "2.0.22";
                sha256 = "sha256-c94Cl64XpiUkUWaI24mKgJzZFaTjTyc5d75T6KFw1O0=";
              }
            ];
          }
        ]
      else
        [ ]
    );
  };
}
