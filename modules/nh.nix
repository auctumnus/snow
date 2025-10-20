{
  config,
  lib,
  username,
  ...
}:
let
  cfg = config.snow.nh;
in
{
  options.snow.nh.enable = lib.mkEnableOption "nh";
  config = lib.mkIf cfg.enable {

    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
      flake = "/home/${username}/snow";
    };
  };
}
