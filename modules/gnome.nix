{
  pkgs,
  config,
  lib,
  inputs,
  username,
  ...
}:
let
  cfg = config.snow.gnome;
in
{
  options.snow.gnome.enable = lib.mkEnableOption "gnome";

  config = lib.mkIf cfg.enable {
    snow = {
      graphical.enable = lib.mkDefault true;
      gtk.enable = lib.mkDefault true;
    };

    services.gnome.gnome-keyring.enable = true;

    system.activationScripts.script.text = ''
      mkdir -p /var/lib/AccountsService/{icons,users}
      cp ${../resources/profile-picture.png} /var/lib/AccountsService/icons/${username}
      echo -e "[User]\nIcon=/var/lib/AccountsService/icons/${username}\n" > /var/lib/AccountsService/users/${username}

      chown root:root /var/lib/AccountsService/users/${username}
      chmod 0600 /var/lib/AccountsService/users/${username}

      chown root:root /var/lib/AccountsService/icons/${username}
      chmod 0444 /var/lib/AccountsService/icons/${username}
    '';

    environment.systemPackages = with pkgs; [
      gnomeExtensions.night-theme-switcher
      hydrapaper-auctumnus
      wl-clipboard
    ];

    home-manager.sharedModules = [
      {
        dconf = {
          enable = true;
          settings."org/gnome/shell" = {
            disable-user-extensions = false;
            enabled-extensions = with pkgs.gnomeExtensions; [
              night-theme-switcher.extensionUuid
            ];
          };
        };

        home.activation.set-wallpapers = inputs.home-manager.lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          hydrapaper=${pkgs.hydrapaper-auctumnus}/bin/hydrapaper

          # set light mode wallpapers
          run $hydrapaper -c ${../resources/wallpaper-light-1.png} ${../resources/wallpaper-light-2.png}

          # set dark mode wallpapers
          run $hydrapaper -d -c ${../resources/wallpaper-dark-1.jpg} ${../resources/wallpaper-dark-2.jpg}
        '';
      }
    ];

    services = {
      # run gnome with autologin (we're always on FDE)
      desktopManager.gnome.enable = true;
      displayManager = {
        gdm.enable = true;
        autoLogin = {
          enable = true;
          user = "autumn";
        };
      };

      xserver = {
        enable = true;

        # configure keymap
        xkb = {
          layout = "us";
          variant = "";
        };
      };

      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };
    # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
    # might not be needed anymore? (as of 10/17)
    systemd.services = {
      "getty@tty1".enable = false;
      "autovt@tty1".enable = false;
    };

    security = {
      # RealtimeKit: allows pipewire to play audio in realtime
      rtkit.enable = true;
      polkit.enable = true;
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true;
          settings =
            let
              open-terminal-keybind = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0";
            in
            {
              "org/gnome/mutter".experimental-features = [
                "variable-refresh-rate"
                # enable fractional scaling
                "scale-monitor-framebuffer"
                "xwayland-native-scaling"
              ];

              # caps lock compose key
              "org/gnome/desktop/input-sources".xkb-options = [ "compose:caps" ];

              "org/gnome/desktop/interface" = {
                clock-format = "12h";
                clock-show-weekday = true;
              };

              # win+shift+q closes active window
              "org/gnome/desktop/wm/keybindings" = {
                close = [ "<Shift><Super>q" ];
                move-to-workspace-1 = [ "<Shift><Super>1" ];
                move-to-workspace-2 = [ "<Shift><Super>2" ];
                move-to-workspace-3 = [ "<Shift><Super>3" ];
                move-to-workspace-4 = [ "<Shift><Super>4" ];
                switch-to-workspace-1 = [ "<Super>1" ];
                switch-to-workspace-2 = [ "<Super>2" ];
                switch-to-workspace-3 = [ "<Super>3" ];
                switch-to-workspace-4 = [ "<Super>4" ];
              };

              # win+return opens terminal
              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/${open-terminal-keybind}/"
                ];
                # disable email and help bindings
                email = pkgs.lib.gvariant.mkEmptyArray (pkgs.lib.gvariant.type.string);
                help = pkgs.lib.gvariant.mkEmptyArray (pkgs.lib.gvariant.type.string);
              };
              "${open-terminal-keybind}" = {
                binding = "<Super>Return";
                command = "${pkgs.ghostty}/bin/ghostty";
                name = "Open Terminal";
              };
            };
        }
      ];
    };
  };
}
