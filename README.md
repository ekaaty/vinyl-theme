# Vinyl Theme for KDE Plasma 6

This theme is a collection of forks and ports of various pieces of artwork for Qt6 and KDE Plasma 6:

* Colors: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/colors/) (native)
* Cursors: [cz-Aviator](https://github.com/charakterziffer/cursor-toolbox/)
* GTK themes: [TODO]
* Global theme: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/lookandfeel/) (native) [TODO]
* Icons: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/icons/) (native) [TODO]
* KSplash: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/splash/) (native)
* Kdecoration: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/kdecoration/) (native)
* Kstyle: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/kstyle/) (native)
* Plasma style: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/desktoptheme/) (native) [IN-PROGRESS]
* Wallpapers: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/wallpapers/) (native) [TODO]

See [AUTHORS](AUTHORS) file and sub-project folders for more info.

## Building the source

### Build Dependencies

You must install at least the following dependencies on your distibution to build this theme:

``cmake``
``cmake(KDecoration2)``
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
``cmake(Qt6DBus)``
``cmake(Qt6Gui)``
``cmake(Qt6UiTools)``
``pkgconfig(epoxy)``
``extra-cmake-modules >= 6.6.0``
``gcc-c++``
``inkscape``
``xcursorgen``
``unzip``

#### 1. Fedora/Nobara and derivatives

Only Fedora 40+ is supported.
Run the following command to install the dependencies:

```shell
dnf install 'cmake' \
  'cmake(KDecoration2)' 'cmake(KF6ConfigWidgets)' 'cmake(KF6Config)' 'cmake(KF6CoreAddons)' \
  'cmake(KF6Crash)' 'cmake(KF6DocTools)' 'cmake(KF6FrameworkIntegration)' \
  'cmake(KF6GlobalAccel)' 'cmake(KF6GuiAddons)' 'cmake(KF6I18n)' 'cmake(KF6IconThemes)' \
  'cmake(KF6KCMUtils)' 'cmake(KF6KIO)' 'cmake(KF6Notifications)' 'cmake(KF6Package)' \
  'cmake(KF6WindowSystem)' 'cmake(KF6KirigamiPlatform)' 'cmake(KWayland)' 'cmake(KWin)' \
  'cmake(Plasma)' 'cmake(Qt6Core)' 'cmake(Qt6DBus)' 'cmake(Qt6Gui)' 'cmake(Qt6UiTools)' \
  'pkgconfig(epoxy)' extra-cmake-modules gcc-c++ inkscape xcursorgen unzip
```

#### 2. OpenSUSE Tumbleweed

Run the following command to install the dependencies (**WARNING**: not verified):

```shell
sudo zypper in --no-recommends \
  git ninja cmake kf6-extra-cmake-modules kf6-kconfig-devel kf6-frameworkintegration-devel \
  gmp-ecm-devel kf6-kconfigwidgets-devel kf6-kguiaddons-devel kf6-ki18n-devel \
  kf6-kiconthemes-devel kf6-kwindowsystem-devel kf6-kcolorscheme-devel kf6-kcoreaddons-devel \
  kf6-kcmutils-devel kcmutils qt6-quick-devel kf6-kirigami-devel qt6-base-devel \
  kdecoration6-devel  qt6-tools qt6-widgets-devel gcc-c++ extra-cmake-modules libQt5Gui-devel \
  libQt5DBus-devel libqt5-qttools-devel libqt5-qtx11extras-devel libQt5OpenGL-devel \
  libQt5Network-devel libepoxy-devel kconfig-devel kconfigwidgets-devel kcrash-devel \
  kglobalaccel-devel ki18n-devel kio-devel kservice-devel kinit-devel knotifications-devel \
  kwindowsystem-devel kguiaddons-devel kiconthemes-devel kpackage-devel kwin5-devel \
  xcb-util-devel xcb-util-cursor-devel xcb-util-wm-devel xcb-util-keysyms-devel \
  inkscape xcursorgen unzip
```

#### 3. Neon/Tuxedo OS

Run the following command to install the dependencies (**WARNING**: not verified):

```shell
sudo apt install \
  git build-essential cmake kf6-extra-cmake-modules kf6-extra-cmake-modules \
  kf6-frameworkintegration-dev kf6-kcmutils-dev kf6-kcolorscheme-dev kf6-kconfig-dev \
  kf6-kconfigwidgets-dev kf6-kcoreaddons-dev kf6-kguiaddons-dev kf6-ki18n-dev \
  kf6-kiconthemes-dev kf6-kirigami2-dev kf6-kpackage-dev kf6-kservice-dev kf6-kwindowsystem-dev \
  kirigami2-dev kwayland-dev libx11-dev libkdecorations2-dev libkf5config-dev \
  libkf5configwidgets-dev libkf5coreaddons-dev libkf5guiaddons-dev libkf5i18n-dev \
  libkf5iconthemes-dev libkf5kcmutils-dev libkf5package-dev libkf5service-dev libkf5style-dev \
  libkf5wayland-dev libkf5windowsystem-dev libplasma-dev libqt5x11extras5-dev qt6-base-dev \
  qt6-declarative-dev qtbase5-dev qtdeclarative5-dev gettext qt6-svg-dev extra-cmake-modules \
  qt3d5-dev inkscape xcursorgen unzip
```

#### 4. Debian/Kubuntu and derivatives

Debian and Kubuntu doesn't support KDE Plasma 6 yet. 
It can be available on Debian 13 (Trixie) and Kubuntu 24.10 (Oracular Oriole).


### Building the source

To build the code, do the following:

```shell
git clone https://github.com/ekaaty/vinyl-theme
export NPROCS=$(grep -c proc /proc/cpuinfo)

cd vinyl-theme
cmake -S . -B build
cmake --build build -j${NPROCS} --verbose
```

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
