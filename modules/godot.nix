{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.snow.godot;
in
{
  options.snow.godot.enable = lib.mkEnableOption "godot";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.godot ];
  };
}
