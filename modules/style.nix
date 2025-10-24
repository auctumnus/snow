{
  pkgs,
  config,
  lib,
  ...
}:
let
  mkFontOption =
    with lib;
    with types;
    kind: {
      package = mkOption {
        type = package;
        description = "chosen ${kind} font; package for the font";
      };
      name = mkOption {
        type = uniq str;
        descripttion = "chosen ${kind} font; name of the font";
      };
    };
in
{
  options.snow = {
    fonts = {
      monospace = mkFontOption "monospace";
      system = mkFontOption "system";
    };
  };

  snow.berkeley-mono.enable = true;
}
