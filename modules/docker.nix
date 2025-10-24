{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.snow.docker;
in
{
  options.snow.docker.enable = lib.mkEnableOption "docker";
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
    };
    users.users.${username}.extraGroups = [ "docker" ];
  };
}
