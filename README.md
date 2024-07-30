# Vinyl Theme for KDE Plasma 6

This theme is a collection of forks and ports of various pieces of artwork for Qt6 and KDE Plasma 6:

* Colors: [ekaaty/vinyl-theme](https://github.com/ekaaty/vinyl-theme/tree/main/colors) (native)
* Cursors: [cz-Aviator](https://github.com/charakterziffer/cursor-toolbox/)
* GTK themes: [breeze-gtk fork](#) ? [TODO]
* Kdecoration: [rileyaft/Lightly](https://github.com/rileyaft/Lightly), [boehs/Lightly](https://github.com/boehs/Lightly)
* Kstyle: [rileyaft/Lightly](https://github.com/rileyaft/Lightly), [boehs/Lightly](https://github.com/boehs/Lightly)
* KSplash: [ekaaty/vinyl-theme] (native) [TODO]
* Icons: [ekaaty/vinyl-theme] (native) [TODO]
* Plasma style: [doncsugar/willow-theme](https://github.com/doncsugar/willow-theme) ? [TODO]
* Wallpapers: [ekaaty/vinyl-theme](#) (native) [TODO]

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
``cmake(Qt6Core)``
``cmake(Qt6DBus)``
``cmake(Qt6Gui)``
``cmake(Qt6UiTools)``
``pkgconfig(epoxy)``
``extra-cmake-modules >= 6.0.0``
``gcc-c++``
``inkscape``
``xcursorgen``
``unzip``

#### 1. Fedora

Only Fedora 40+ is supported.
Run the following command to install the dependencies:

```shell
dnf install 'cmake' \
  'cmake(KDecoration2)' 'cmake(KF6ConfigWidgets)' 'cmake(KF6Config)' \
  'cmake(KF6CoreAddons)' 'cmake(KF6Crash)' 'cmake(KF6FrameworkIntegration)' \
  'cmake(KF6GlobalAccel)' 'cmake(KF6GuiAddons)' 'cmake(KF6I18n)' 'cmake(KF6IconThemes)' \
  'cmake(KF6KCMUtils)' 'cmake(KF6KIO)' 'cmake(KF6Notifications)' 'cmake(KF6Package)' \
  'cmake(KF6WindowSystem)' 'cmake(KF6KirigamiPlatform)' 'cmake(KWayland)' 'cmake(KWin)' \
  'cmake(Qt6Core)' 'cmake(Qt6DBus)' 'cmake(Qt6Gui)' 'cmake(Qt6UiTools)' 'pkgconfig(epoxy)' \
  extra-cmake-modules gcc-c++ inkscape xcursorgen unzip
```

To build the code, do the following:

```shell
git clone https://github.com/ekaaty/vinyl-theme

export NPROCS=$(grep -c proc /proc/cpuinfo)

cd vinyl-theme
cmake -S . -B build
cmake --build build -j${NPROCS} --verbose
```

And, finally, to install the files execute the following (will install it to the DESTDIR/PREFIX
directory):

```shell
# On non-Fedora systems you can change PREFIX variable to match your KDE instalation
export PREFIX=/usr
export DESTDIR=/

cd vinyl-theme
cmake --install build --prefix ${PREFIX}
```
