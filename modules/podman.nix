{
  config,
  lib,
  username,
  pkgs,
  ...
}:
let
  cfg = config.snow.podman;
in
{
  options.snow.podman.enable = lib.mkEnableOption "podman";
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.snow.docker.enable;
        message = "docker conflicts with podman";
      }
    ];
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    users.users.${username}.extraGroups = [ "podman" ];
    environment.systemPackages = with pkgs; [
      podman-tui
      podman-compose
    ];
  };
}
