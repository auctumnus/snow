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
      # home-manager
      inputs.home-manager.nixosModules.home-manager
      # nixvim
      inputs.nixvim.nixosModules.nixvim
      {
        nixpkgs.overlays = [
          self.overlays.default
        ];

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
