{
  lib,
  python3Packages,
  fetchFromGitLab,
  meson,
  ninja,
  glib,
  pkg-config,
  pandoc,
  appstream,
  blueprint-compiler,
  gobject-introspection,
  wrapGAppsHook4,
  dbus,
  libadwaita,
  xdg-user-dirs,
}:

python3Packages.buildPythonApplication rec {
  pname = "hydrapaper";
  version = "3.3.2-auctumnus";
  pyproject = false;

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "auctumnus";
    repo = "HydraPaper";
    rev = "bd1a48f336293470207f65eeaed5384edcef7812";
    hash = "sha256-za5MZOEnrUem413YEFJ0a2QCmgCpaL6emmBKTcZMuCM=";
  };

  nativeBuildInputs = [
    meson
    ninja
    glib
    pkg-config
    pandoc
    appstream
    blueprint-compiler
    gobject-introspection
    wrapGAppsHook4
  ];

  buildInputs = [
    dbus
    glib
    libadwaita
  ];

  propagatedBuildInputs = with python3Packages; [
    dbus-python
    pygobject3
    pillow
  ];

  # wrapGAppsHook4 propagates gtk4 -- which provides gtk4-update-icon-cache instead
  postPatch = ''
    substituteInPlace meson_post_install.py \
      --replace-fail gtk-update-icon-cache gtk4-update-icon-cache
  '';

  dontWrapGApps = true;

  preFixup = ''
    gappsWrapperArgs+=(
      --prefix PATH : ${
        lib.makeBinPath [
          glib
          xdg-user-dirs
        ]
      }
    )
    makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';

  meta = {
    description = "GNOME utility for setting different wallpapers on individual monitors";
    homepage = "https://hydrapaper.gabmus.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ lachrymal ];
    mainProgram = "hydrapaper";
    platforms = lib.platforms.linux;
  };
}
