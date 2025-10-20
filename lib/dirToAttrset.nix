let
  # Helper functions (avoiding lib dependency)
  hasSuffix =
    suffix: str:
    let
      suffixLen = builtins.stringLength suffix;
      strLen = builtins.stringLength str;
    in
    strLen >= suffixLen && builtins.substring (strLen - suffixLen) suffixLen str == suffix;

  removeSuffix =
    suffix: str:
    let
      suffixLen = builtins.stringLength suffix;
      strLen = builtins.stringLength str;
    in
    if hasSuffix suffix str then builtins.substring 0 (strLen - suffixLen) str else str;

  # Check if a directory has a default.nix file (with error handling)
  hasDefaultNix =
    dirPath:
    let
      contents = builtins.tryEval (builtins.readDir dirPath);
    in
    contents.success && contents.value ? "default.nix" && contents.value."default.nix" == "regular";

  # Function to convert a directory of .nix files to an attribute set
  dirToAttrset =
    dir:
    let
      # Read directory contents with error handling
      entriesResult = builtins.tryEval (builtins.readDir dir);

      # Early return if directory doesn't exist or can't be read
      entries =
        if !entriesResult.success then
          throw "dirToAttrset: Cannot read directory ${toString dir}"
        else
          entriesResult.value;

      # Process each entry - returns { name, value } or null
      processEntry =
        name: type:
        if type == "regular" && hasSuffix ".nix" name then
          # Regular .nix file - remove .nix extension for attribute name
          {
            name = removeSuffix ".nix" name;
            value = dir + "/${name}";
          }
        else if type == "directory" && hasDefaultNix (dir + "/${name}") then
          # Directory with default.nix - use directory name as-is
          {
            name = name;
            value = dir + "/${name}";
          }
        else
          # Skip everything else (non-nix files, directories without default.nix)
          null;

      # More efficient: use builtins.concatMap to filter and map in one pass
      result = builtins.listToAttrs (
        builtins.concatMap (
          name:
          let
            entry = processEntry name entries.${name};
          in
          if entry == null then [ ] else [ entry ]
        ) (builtins.attrNames entries)
      );

    in
    result;

in
dirToAttrset

# Example usage:
# let
#   moduleFiles = dirToAttrset ./modules;
# in moduleFiles
#
# Given a directory structure like:
# ./modules/
# ├── pds.nix
# ├── syncthing.nix
# └── xcompose/
#     ├── default.nix
#     └── XCompose
#
# This would produce:
# {
#   pds = ./modules/pds.nix;
#   syncthing = ./modules/syncthing.nix;
#   xcompose = ./modules/xcompose;
# }
