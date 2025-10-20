{
  pkgs,
  hostname,
  username,
  ...
}:
{
  snow = {
    shell.enable = true;
    ssh.enable = true;
    nh.enable = true;
    git.enable = true;
    tailscale.enable = true;
  };

  # enable what should be default...
  # nix-command turns on `nix run`, `nix shell`, etc
  # flakes enables flakes support
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # in future, this could just be an unfree predicate
  # in practice it's kind of too annoying to deal w/ that
  nixpkgs.config.allowUnfree = true;
  home-manager.sharedModules = [
    {
      home.file.".config/nixpkgs/config.nix".text = "{ allowUnfree = true; }";
    }
  ];

  networking = {
    # hostname gets passed in from mkSystem
    hostName = hostname;
    networkmanager.enable = true;
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Autumn";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    shell = pkgs.fish;
  };

  # cpu microcode and such
  hardware.enableRedistributableFirmware = true;
}
