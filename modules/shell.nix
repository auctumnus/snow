# common shell utilities etc
# need to figure out in which ways to split this from `hosts/default.nix`...
{
  pkgs,
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  cfg = config.snow.shell;
in
{
  options.snow.shell.enable = lib.mkEnableOption "shell";

  config = lib.mkIf cfg.enable {
    snow = {
      gpg.enable = lib.mkDefault true;
      nixvim.enable = lib.mkDefault true;
      senpai.enable = lib.mkDefault true;
    };

    home-manager.sharedModules = [
      {
        home.sessionPath = [ "$HOME/.local/share/npm" ];
        programs = {
          eza = {
            enable = true;
            git = true;
            icons = "auto";
          };
          tmux = {
            enable = true;
            sensibleOnTop = true;
            extraConfig = ''
              set -g status-bg "colour10"
              set -g status-fg "colour255"
            '';
          };
          zoxide = {
            enable = true;
            options = [ "--cmd cd" ];
          };
          direnv = {
            enable = true;
            nix-direnv.enable = true;
          };
          bat = {
            enable = true;
          };
          fish = {
            enable = true;
            interactiveShellInit = ''
              set fish_greeting
              set -U fish_key_bindings fish_hybrid_key_bindings

              function nr
                  if string match -q '*[#:]*' -- $argv[1]
                      nix run $argv[1]
                  else
                      nix run nixpkgs#$argv[1]
                  end
              end

              function ns
                  if string match -q '*[#:]*' -- $argv[1]
                      nix shell $argv[1]
                  else
                      nix shell nixpkgs#$argv[1]
                  end
              end
            '';

            shellInit = ''
              export PATH="/home/autumn/.local/share/npm/bin:$PATH"
            '';

            shellAliases = {
              ls = "eza";
              la = "ls -la";
              d = "function _d; eval $argv; ${pkgs.libnotify}/bin/notify-send \"Done: $argv\"; end; _d";
            };

            plugins = [
              {
                name = "tide";
                src = inputs.tide;
              }
            ];
          };
        };
      }
    ];

    environment.systemPackages = with pkgs; [
      git
      killall
      tree
      zip
      unzip
      tealdeer # tldr
      man-pages
      man-pages-posix
      ripgrep
      bottom
      file
      fzf
      fd
      httpie
      jq
      inputs.please.packages.${pkgs.system}.default
      ntfy-sh
    ];

    # man pages
    documentation.dev.enable = true;

    programs = {
      fish = {
        enable = true;
      };
    };
  };
}
