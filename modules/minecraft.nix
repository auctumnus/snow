{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.snow.minecraft;
in
{
  options.snow.minecraft.enable = lib.mkEnableOption "minecraft";

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      prismlauncher
      javaPackages.compiler.temurin-bin.jre-25
    ];
  };
}
