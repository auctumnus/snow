{
  config,
  lib,
  ...
}:
let
  cfg = config.snow.ssh;
in
{
  options.snow.ssh.enable = lib.mkEnableOption "ssh";
  config = lib.mkIf cfg.enable {
    snow.gpg.enable = true; # we use the gpg-agent for ssh
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };
    home-manager.sharedModules = [
      {
        programs.ssh.enable = true;
      }
    ];
  };
}
