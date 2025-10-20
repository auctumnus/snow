{
  self,
  inputs,
  nixpkgs,
}:
rec {
  dirToAttrset = import ./dirToAttrset.nix;
  mkSystem = import ./mkSystem.nix { inherit self inputs nixpkgs; };
  # mkSystems takes a list of objects as expected by mkSystem and turns it into an attrset
  # which is suitable for outputs.nixosConfigurations
  mkSystems =
    systems:
    let
      systematize = system: {
        name = system.hostname;
        value = (mkSystem system);
      };
      systematized = map systematize systems;
    in
    builtins.listToAttrs systematized;
}
