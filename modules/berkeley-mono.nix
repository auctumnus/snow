{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.snow.berkeley-mono;
  fontDir = "/var/lib/berkeley-mono-fonts";
in
{
  options.snow.berkeley-mono.enable = lib.mkEnableOption "berkeley-mono";
  config = lib.mkIf cfg.enable {
    age.secrets."berkeley-mono.age" = {
      file = ../packages/berkeley-mono/berkeley-mono.age;
    };

    # Create the font directory and extract fonts at activation time
    system.activationScripts.berkeley-mono-fonts = lib.stringAfter [ "agenix" ] ''
      mkdir -p ${fontDir}

      # Extract fonts from the encrypted zip if not already done
      if [ ! -f ${fontDir}/.extracted ]; then
        ${pkgs.unzip}/bin/unzip -o ${config.age.secrets."berkeley-mono.age".path} -d ${fontDir}
        touch ${fontDir}/.extracted
      fi
    '';

    # Register the font directory
    fonts.fontDir.enable = true;
    system.fsPackages = [
      (pkgs.runCommand "berkeley-mono-fonts" {} ''
        mkdir -p $out/share/fonts/opentype
        ln -s ${fontDir}/*.otf $out/share/fonts/opentype/ || true
      '')
    ];

    # Alternative: directly add the directory to fonts.fontconfig
    fonts.fontconfig.localConf = ''
      <dir>${fontDir}</dir>
    '';
  };
}
