# Vinyl Theme for KDE Plasma 6

This theme is a collection of libraries and artwork, some was initially forks and ports of various other 
pieces of code and graphics work for KDE Plasma 6:

>[!NOTE]
>This software is on development for KDE Plasma version 6 (and related to Qt6) and can't run on previous versions of Plasma.

![Desktop showing Dolphin, Vinyl Launcher and Filelight in a purple way](.github/pages/img/screenshot0.webp)

- [x] Application style: [vinyl-theme/kstyle](https://github.com/ekaaty/vinyl-theme/tree/main/kstyle/)
- [x] Color schemes: [vinyl-theme/colors](https://github.com/ekaaty/vinyl-theme/tree/main/colors/)
- [x] Cursor themes: [vinyl-theme/cursors](https://github.com/ekaaty/vinyl-theme/tree/main/cursors/)
- [x] Firefox themes: [vinyl-theme/mozilla](https://github.com/ekaaty/vinyl-theme/tree/main/mozilla/)
- [x] Global themes: [vinyl-theme/plasma/look-and-feel](https://github.com/ekaaty/vinyl-theme/tree/main/plasma/look-and-feel/)
- [x] Icon themes: [vinyl-theme/icons](https://github.com/ekaaty/vinyl-theme/tree/main/icons/)
- [x] Konsole profiles: [vinyl-theme/konsole](https://github.com/ekaaty/vinyl-theme/tree/main/konsole/)
- [x] Menu launcher: [vinyl-theme/plasma/plasmoids/launcher](https://github.com/ekaaty/vinyl-theme/tree/main/plasma/plasmoids/launcher/)
- [x] Plasma layouts: [vinyl-theme/plasma/layout-templates](https://github.com/ekaaty/vinyl-theme/tree/main/plasma/layout-templates/)
- [x] Plasma style: [vinyl-theme/plasma/desktoptheme](https://github.com/ekaaty/vinyl-theme/tree/main/plasma/desktoptheme/)
- [x] SDDM theme: [sddm-theme/sddm](https://github.com/ekaaty/vinyl-theme/tree/main/sddm)
- [x] Splash screen: [vinyl-theme/splash](https://github.com/ekaaty/vinyl-theme/tree/main/splash/)
- [x] Wallpapers: [vinyl-theme/wallpapers](https://github.com/ekaaty/vinyl-theme/tree/main/wallpapers/)
- [x] Window decoration: [vinyl-theme/kdecoration](https://github.com/ekaaty/vinyl-theme/tree/main/kdecoration/)
- [ ] GTK themes: external ([Fluent-compact](https://store.kde.org/p/1477941/))
- [ ] Plymounth theme: planned
- [ ] Grub2 theme: planned

See [AUTHORS.md](AUTHORS.md) file and sub-project folders for more info.

## Installing pre-built binaries

### 1\. Fedora/Nobara

You can install Vinyl nativelly on [Fedora](https://fedoraproject.org/kde/), [Nobara](https://nobaraproject.org) 
and derivated distros by enabling the [ekaaty/kde-extras](https://copr.fedorainfracloud.org/coprs/ekaaty/kde-extras)
COPR repository. To enable this repository and install packages run:

```
sudo dnf copr enable ekaaty/kde-extras
sudo dnf upgrade
sudo dnf install vinyl-theme
```
### 2\. Kinoite/Bazzite (and other Fedora based immutable)

If you are running Fedora [Kinoite](https://fedoraproject.org/atomic-desktops/kinoite/) or 
[Bazzite](https://bazzite.gg/), also you can install Vinyl from the 
[ekaaty/kde-extras](https://copr.fedorainfracloud.org/coprs/ekaaty/kde-extras) COPR repository. 
To enable this repository and install packages run:

```
sudo ostree remote add ekaaty-kde-extras \
  https://download.copr.fedorainfracloud.org/results/ekaaty/kde-extras/fedora-$releasever-$basearch/
sudo rpm-ostree upgrade
sudo rpm-ostree install --apply-live vinyl-theme
```

### 3\. Arch and derivatives (Manjaro/EndeavourOS/CachyOS/Garuda)

The package is available to be installed from the Arch Linux AUR.

https://aur.archlinux.org/packages/vinyl

This package uses the viny-theme code from the latest release tag.

You can use your favorite Arch AUR helper to install it.
Example:

```shell
yay -Syu
yay -S --needed base-devel vinyl
```
> [!NOTE]
> Please do not report any issues with the AUR package in this repository.

Instead either use the AUR comment system / https://github.com/DeltaCopy/vinyl-aur-ci/issues


## Building from source (manual build)

### Build Dependencies

You must install at least the following dependencies on your distibution to
build this theme:

``cmake``
``cmake(KDecoration3)``
``cmake(KF6ConfigWidgets)``
``cmake(KF6Config)``
``cmake(KF6CoreAddons)``
``cmake(KF6Crash)``
``cmake(KF6DocTools)``
``cmake(KF6FrameworkIntegration)``
``cmake(KF6GlobalAccel)``
``cmake(KF6GuiAddons)``
``cmake(KF6I18n)``
``cmake(KF6IconThemes)``
``cmake(KF6KCMUtils)``
``cmake(KF6KIO)``
``cmake(KF6Notifications)``
``cmake(KF6Package)``
``cmake(KF6WindowSystem)``
``cmake(KF6KirigamiPlatform)``
``cmake(KWayland)``
``cmake(KWin)``
``cmake(Plasma)``
``cmake(Qt6Core)``
``cmake(Qt6Core5Compat)``
``cmake(Qt6DBus)``
``cmake(Qt6Gui)``
``cmake(Qt6UiTools)``
``pkgconfig(epoxy)``
``python3dist(cairosvg)``
``python3dist(lxml)``
``extra-cmake-modules >= 6.13.0``
``gcc-c++``
``git``
``unzip``
``xcursorgen``

#### 1\. Fedora and derivatives (Nobara/Kinoite/Bazzite and others)

Run the following command to install the dependencies:

```shell
dnf install 'cmake' \
  'cmake(KDecoration3)' 'cmake(KF6ConfigWidgets)' 'cmake(KF6Config)' 'cmake(KF6CoreAddons)' \
  'cmake(KF6Crash)' 'cmake(KF6DocTools)' 'cmake(KF6FrameworkIntegration)' \
  'cmake(KF6GlobalAccel)' 'cmake(KF6GuiAddons)' 'cmake(KF6I18n)' 'cmake(KF6IconThemes)' \
  'cmake(KF6KCMUtils)' 'cmake(KF6KIO)' 'cmake(KF6Notifications)' 'cmake(KF6Package)' \
  'cmake(KF6WindowSystem)' 'cmake(KF6KirigamiPlatform)' 'cmake(KWayland)' 'cmake(KWin)' \
  'cmake(Plasma)' 'cmake(Qt6Core)' 'cmake(Qt6Core5Compat)' 'cmake(Qt6DBus)' 'cmake(Qt6Gui)' \
  'cmake(Qt6UiTools)' 'pkgconfig(epoxy)' 'python3dist(cairosvg)' 'python3dist(lxml)' \
  'extra-cmake-modules' 'gcc-c++' 'git' 'xcursorgen' 'unzip'
```

#### 2\. OpenSUSE (Tumbleweed only)
>[!IMPORTANT]
>OpenSUSE Leap 15.6 doesn't supports Plasma 6, so you can't build Vinyl for it.

Run the following command to install the dependencies:

```shell
sudo zypper in --allow-downgrade --no-recommends 'cmake' \
  'cmake(KDecoration3)' 'cmake(KF6ConfigWidgets)' 'cmake(KF6Config)' 'cmake(KF6CoreAddons)' \
  'cmake(KF6Crash)' 'cmake(KF6DocTools)' 'cmake(KF6FrameworkIntegration)' \
  'cmake(KF6GlobalAccel)' 'cmake(KF6GuiAddons)' 'cmake(KF6I18n)' 'cmake(KF6IconThemes)' \
  'cmake(KF6KCMUtils)' 'cmake(KF6KIO)' 'cmake(KF6Notifications)' 'cmake(KF6Package)' \
  'cmake(KF6WindowSystem)' 'cmake(KF6KirigamiPlatform)' 'cmake(KWayland)' 'cmake(KWin)' \
  'cmake(Plasma)' 'cmake(Qt6Core)' 'cmake(Qt6Core5Compat)' 'cmake(Qt6DBus)' 'cmake(Qt6Gui)' \
  'cmake(Qt6UiTools)' 'pkgconfig(epoxy)' 'python3-CairoSVG' 'python3-lxml' \
  'extra-cmake-modules' 'gcc-c++' 'git' 'xcursorgen' 'unzip'
```

#### 3\. Debian and derivatives (Kubuntu/Neon/Tuxedo OS and others)

>[!IMPORTANT]
>Kubuntu 24.04 LTS doesn't support KDE Plasma 6 yet. Otherwise it's available on Kubuntu 24.10+
>and current versions of Debian (Trixie), KDE Neon and Tuxedo OS.

If you're running Plasma 6 on one of supported distributions, run the following command to install
the dependencies:

```shell
sudo apt install 'cmake' \
  'libkdecorations3-dev' 'libkf6configwidgets-dev' 'libkf6config-dev' 'libkf6coreaddons-dev' \
  'libkf6doctools-dev' 'libkf6style-dev' 'libkf6globalaccel-dev' 'libkf6guiaddons-dev' \
  'libkf6i18n-dev' 'libkf6iconthemes-dev' 'libkf6kcmutils-dev' 'libkf6kio-dev' \
  'libkf6notifications-dev' 'libkf6package-dev' 'libkf6windowsystem-dev' 'libkirigami-dev' \
  'kirigami2-dev' 'kwayland-dev' 'kwin-dev' 'libplasma-dev' 'qt6-base-dev' 'qt6-5compat-dev' \
  'libqt6gui6' 'libqt6uitools6' 'libepoxy-dev' 'build-essential' 'git' 'python3-lxml' \
  'python3-cairosvg' 'x11-apps' 'unzip'
```

#### 4\. Arch and derivatives (Manjaro/EndeavourOS/CachyOS/Garuda and others)

Run the following command to install the dependencies:

```shell
sudo pacman -Sy --needed 'cmake' \
  'base-devel' 'git' 'cmake' 'extra-cmake-modules' 'git' 'kdecoration' 'kdeplasma-addons' 'qt6-declarative' \
  'kcoreaddons' 'kcmutils' 'kcolorscheme' 'kconfig' 'kguiaddons' 'kiconthemes' 'kwindowsystem' \
  'kdoctools' 'kpackage' 'frameworkintegration' 'python-cairosvg' 'python-lxml' \
  'xorg-xcursorgen' 'gcc' 'unzip'
```

#### 5\. Alpine and derivatives

Run the following command to install the dependencies (not tested):

```shell
sudo apk -U add 'build-base' 'kconfigwidgets-dev' 'kdecoration-dev' 'kguiaddons-dev' 'ki18n-dev' \
  'kiconthemes-dev' 'kpackage-dev' 'kwindowsystem-dev' 'extra-cmake-modules' 'git' 'py3-lxml' \
  'py3-cairosvg'
```

#### 6\. NixOS

Add the repo as a flake input:

```nix
inputs = {
  vinyl-theme = {
    url = "github:ekaaty/vinyl-theme";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

And add it as a nixpkgs overlay:

```nix
outputs = { nixpkgs, vinyl-theme, ... }: {
  nixosConfigurations.my-nixos = nixpkgs.lib.nixosSystem {
    modules = [
      vinyl-theme.nixosModules.nixpkgs-overlay
      ./configuration.nix
    ]
  }
}

# configuration.nix:
{
  environment.systemPackages = [
    pkgs.vinyl-theme
  ];
}
```

### Building the source

To build the code, do the following:

```shell
git clone https://github.com/ekaaty/vinyl-theme
export NPROCS=$(grep -c proc /proc/cpuinfo)

cd vinyl-theme
cmake -S . -B build
cmake --build build -j${NPROCS}
```

To build only application style and decoration, use:

```shell
cd vinyl-theme
cmake -DWITH_APPSTYLE_ONLY=ON -S . -B build
cmake --build build -j${NPROCS}
```
>[!NOTE]
>To debug the setup install, please use "-j1 --verbose | tee build.log" instead of "-j${NPROCS}"

### Installing the built files

And, finally, to install the files execute the following (will install it to the DESTDIR/PREFIX
directory):

```shell
# On non-Fedora systems you can change PREFIX variable (eg. PREFIX=/usr/local) to
# match your KDE instalation
export PREFIX=$([ $(id -u) -eq 0 ] && echo /usr || echo ~/.local)

cd vinyl-theme
cmake --install build --prefix ${PREFIX}
```
