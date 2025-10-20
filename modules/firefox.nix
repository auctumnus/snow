{ config, lib, ... }:
let
  cfg = config.snow.firefox;
in
{
  options.snow.firefox.enable = lib.mkEnableOption "firefox";

  config = lib.mkIf cfg.enable {
    programs.firefox.enable = true;
    # TODO: it would be really nice to somehow sync my preferences and extensions
    # it _seems_ like preferences are possible, extensions are kind of a pain,
    # extension _settings_ are extremely painful
  };
}
