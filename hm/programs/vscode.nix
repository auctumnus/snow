{ pkgs, ... }:
{
  imports = [
    ./vscode/theme.nix
  ];
  home.packages = with pkgs; [
    nil
    ruff
  ];
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      github.copilot
      jnoortheen.nix-ide
      tamasfe.even-better-toml
      rust-lang.rust-analyzer
      ms-azuretools.vscode-docker
      github.copilot-chat
      vue.volar
      mkhl.direnv
      ms-python.python
      charliermarsh.ruff
      bradlc.vscode-tailwindcss
      esbenp.prettier-vscode
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-coverage-gutters";
        publisher = "ryanluker";
        version = "2.11.1";
        sha256 = "sha256-Ne80F5BkAlzeEqAaJErlzTdlv8RDMwShgrVPaSYqRYg=";
      }
      {
        name = "live-server";
        publisher = "ms-vscode";
        version = "0.5.2024062701";
        sha256 = "sha256-03UXPaoW7DpApaLFJyZRdTKfCDbXudglFC7Dwj4w8yo=";
      }
    ];
    userSettings = {
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "workbench.colorTheme" = "Autumn Material Light";
    };
  };
}
