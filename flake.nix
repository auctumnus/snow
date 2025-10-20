{
  description = "Autumn's flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-parts,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = import ./lib { inherit self inputs nixpkgs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ treefmt-nix.flakeModule ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              deadnix.enable = true; # checks for dead code in nix
              mdformat.enable = true;
            };
          };
          packages = {
            # fork of hydrapaper until the commit lands
            hydrapaper-auctumnus = pkgs.callPackage ./packages/hydrapaper-auctumnus/package.nix { };
          };
        };
      flake = {
        overlays.default = _final: prev: {
          hydrapaper-auctumnus = self.packages.${prev.system}.hydrapaper-auctumnus;
        };
        nixosModules = lib.dirToAttrset ./modules;
        nixosConfigurations = lib.mkSystems [
          { hostname = "hickory"; }
        ];
      };
    };
}
