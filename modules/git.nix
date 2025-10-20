{
  config,
  lib,
  ...
}:
let
  cfg = config.snow.git;
in
{
  options.snow.git.enable = lib.mkEnableOption "git";
  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
        user = {
          name = "Autumn";
          email = "auctumnus@pm.me";
          signingKey = "E1542373839B2670";
        };
      };
    };
  };
}
