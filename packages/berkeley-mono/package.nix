{
  stdenvNoCC,
  secret,
  unzip,
}:

stdenvNoCC.mkDerivation {
  pname = "berkeley-mono";
  version = "0-unstable-2025-07-30";

  src = ./.;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    out_dir=$(mktemp -d)

    ${unzip}/bin/unzip ${secret.path} -d "$out_dir"

    install -Dm644 "$out_dir"/*.otf -t $out/share/fonts/opentype/

    runHook postInstall
  '';
}
