# common shell utilities etc
# need to figure out in which ways to split this from `hosts/default.nix`...
{
  pkgs,
  lib,
  config,
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
        programs.eza = {
          enable = true;
          git = true;
          icons = "auto";
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
    ];

    # man pages
    documentation.dev.enable = true;

    programs = {
      fish = {
        enable = true;
        interactiveShellInit = ''
          set fish_greeting
          ${pkgs.starship}/bin/starship init fish | source
        '';

        shellInit = ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
        shellAliases = {
          ls = "eza";
          la = "ls -la";
          d = "function _d; eval $argv; ${pkgs.libnotify}/bin/notify-send \"Done: $argv\"; end; _d";
        };
      };

      # TODO: replace with our own
      starship = {
        enable = true;
        settings = pkgs.lib.importTOML ../resources/starship.toml;
      };
      zoxide = {
        enable = true;
        flags = [ "--cmd cd" ];
      };
      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };
      bat = {
        enable = true;
      };
    };
  };
}
