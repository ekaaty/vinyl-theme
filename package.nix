{
  lib,
  stdenv,
  cmake,
  extra-cmake-modules,
  gettext,
  kdePackages,
  python3,
  python3Packages,
  qt6Packages,
  xorg,
}:
stdenv.mkDerivation {
  pname = "vinyl-theme";
  version = (lib.strings.trim (builtins.readFile ./VERSION));

  outputs = [
    "out"
  ];

  src = ./.;

  preBuild = ''
    # Cursors are rendered from SVG to PNG using cairosvg, which uses Fontconfig.
    # Fontconfig complains about there being no writable cache directories.
    export XDG_CACHE_HOME=$PWD/cache;
  '';

  postPatch = ''
    patchShebangs --build .

    # Ensure PROJECT_DATE cmake variable is not based on commit metadata.
    declare -a cmakeListsDeclaringProjectDate
    readarray -t cmakeListsDeclaringProjectDate < <(
      find -type f -iname CMakeLists.txt \
        | xargs grep -l 'OUTPUT_VARIABLE PROJECT_DATE'
    )

    substituteInPlace "''${cmakeListsDeclaringProjectDate[@]}" \
      --replace-fail '"date +%y.%1m.%1d -d \"$(git log -n 1 --pretty=format:%cD 2>/dev/null)\""' "\"echo 1970.01.01\""
  '';

  nativeBuildInputs = [
    # Build system.
    cmake
    extra-cmake-modules
    kdePackages.extra-cmake-modules
    gettext

    # Cursors.
    python3
    python3Packages.cairosvg
    python3Packages.lxml
    xorg.xcursorgen

    # Hooks.
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.frameworkintegration
    kdePackages.kcmutils
    kdePackages.kcolorscheme
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kdecoration
    kdePackages.kguiaddons
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kirigami
    kdePackages.kpackage
    kdePackages.kservice
    kdePackages.kwayland
    kdePackages.kwindowsystem
    kdePackages.libplasma
    qt6Packages.qtbase
    qt6Packages.qtdeclarative
    qt6Packages.qtsvg
    xorg.libX11
  ];

  meta = {
    description = "A theme for KDE Plasma";
    homepage = "https://github.com/ekaaty/vinyl-theme";
    license = with lib.licenses; [
      gpl2
      mit
    ];
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
}
