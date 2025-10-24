{
  self,
  inputs,
  nixpkgs,
}:
{
  hostname,
  modules ? [ ],
}:
let
  username = "autumn";
in
nixpkgs.lib.nixosSystem {
  specialArgs = {
    inherit inputs hostname username;
  };
  modules =
    # our custom modules
    (builtins.attrValues inputs.self.nixosModules)
    ++ [
      # common nixos config
      ./../hosts
      # per-system config
      ./../hosts/${hostname}
      inputs.home-manager.nixosModules.home-manager
      inputs.nixvim.nixosModules.nixvim
      inputs.agenix.nixosModules.default
      {
        nixpkgs.overlays = [
          self.overlays.default
        ];

        age.identityPaths = [ "/home/${username}/.ssh/id_ed25519" ];

        environment.systemPackages = [ inputs.agenix.packages.x86_64-linux.default ];

        home-manager = {
          # use global `pkgs` from nixos; prevents extra nixpkgs evaluation
          useGlobalPkgs = true;
          # install packages to /etc/profiles instead of $HOME/.nix-profile
          useUserPackages = true;
          users.${username}.home = {
            username = username;
            homeDirectory = "/home/${username}";
            stateVersion = "25.05";
          };
        };
      }
    ]
    ++ modules;
}
