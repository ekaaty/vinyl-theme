# Vinyl Next Theme for KDE Plasma 6+

***

This theme is an *EXPERIMENTAL* approach to refactor Vinyl without fork Breeze or start from another base. It's writen from scratch expanding the source-code of Breeze, but not including it. The common portion between the Kdecoration and Kstyle is developed in Rust, providing a performance and security focused core for the project. 

> [!NOTE] 
> THIS PROJECT IS INCOMPLETE AND UNSTABLE AND NOT AIMED TO RUN IN PRODUCTION. USE AT YOUR OWN RISK.

***

## Building from source (manual build)

This project is developed using CMake with Ninja as Makefile generator and CMake presets to
made the configure/build/install workflow as simple as possible.

### 1. Install the Build Dependencies

You must run this command to install at least the following dependencies on your distibution to
build this theme (tested only on Fedora and derivatives):

```shell
dnf install 'cmake' \
  'cmake(KDecoration3)' 'cmake(KF6ConfigWidgets)' 'cmake(KF6Config)' 'cmake(KF6CoreAddons)' \
  'cmake(KF6Crash)' 'cmake(KF6DocTools)' 'cmake(KF6FrameworkIntegration)' \
  'cmake(KF6GlobalAccel)' 'cmake(KF6GuiAddons)' 'cmake(KF6I18n)' 'cmake(KF6IconThemes)' \
  'cmake(KF6KCMUtils)' 'cmake(KF6KIO)' 'cmake(KF6Notifications)' 'cmake(KF6Package)' \
  'cmake(KF6WindowSystem)' 'cmake(KF6KirigamiPlatform)' 'cmake(KWayland)' 'cmake(KWin)' \
  'cmake(Plasma)' 'cmake(Qt6Core)' 'cmake(Qt6Core5Compat)' 'cmake(Qt6DBus)' 'cmake(Qt6Gui)' \
  'cmake(Qt6UiTools)' 'pkgconfig(epoxy)' 'python3dist(cairosvg)' 'python3dist(lxml)' \
  'extra-cmake-modules' 'git' 'gcc-c++' 'ninja-build' \
  'cargo' 'clippy' 'rust' 'rustfmt' \
  'xcursorgen' 'unzip'
```

### 2. Configuring the source for building

To configure the source code for building, do the following:

```shell
# You can change KDE_PREFIX variable (eg. KDE_PREFIX=/usr/local) to match your KDE instalation
KDE_PREFIX=$(pkg-config --variable=prefix KF6CoreAddons 2>/dev/null || echo "/usr/local")

# Set the install PREFIX to system or user directory
export PREFIX=$([ $(id -u) -eq 0 ] && echo "${KDE_PREFIX}" || echo "$HOME/.local")

# Set this to ON if you want to build *ONLY* the application style and decoration
export APPSTYLE_ONLY=OFF

# Get the source from Git repository
git clone https://github.com/ekaaty/vinyl-theme -b vinyl-next vinyl-next
cd vinyl-next
```

You can configure the code using CMake presets:

```shell
PREFIX=${PREFIX} cmake --preset default-config -DWITH_APPSTYLE_ONLY=${APPSTYLE_ONLY}
```

Or do the same using CMake/Ninja:

```shell
PREFIX=${PREFIX} cmake  -DWITH_APPSTYLE_ONLY=${APPSTYLE_ONLY} -S . -B build -G Ninja
```

### 3. Build the configured source

Now, to build the application style, decoration, and the other theme pieces, use:

```shell
export NPROCS=$(grep -c proc /proc/cpuinfo)
```

To build using CMake presets, run:

```shell
cmake --build --preset default-build -j${NPROCS}
```

Or to build using Ninja:

```shell
ninja -C build build -j${NPROCS}
```

Or if you prefer build with pure cmake, run:

```shell
cmake --build build -j${NPROCS}
```

>[!NOTE]
>To debug the setup install, please use "-j1 --verbose | tee build.log" instead of "-j${NPROCS}"

### 4. Installing the built files

And, finally, to install the files execute the following (will install it to the DESTDIR/PREFIX
directory):

```shell
# Your KDE_PREFIX variable must match your KDE instalation (eg. KDE_PREFIX=/usr/local)
KDE_PREFIX=$(pkg-config --variable=prefix KF6CoreAddons 2>/dev/null || echo "/usr/local")

if [ $(id -u) -eq 0 ]; then
    export PREFIX="${KDE_PREFIX}"
    CMD_PREFIX="PREFIX=${PREFIX} sudo -E"
else
    export PREFIX="$HOME/.local"
    CMD_PREFIX=""
fi
```

Install the built files using CMake presets:

```shell
${CMD_PREFIX} cmake --build --preset default-install
```

Or using Ninja:

```shell
${CMD_PREFIX} ninja -C build install
```

If you prefer using pure cmake command:

```shell
${CMD_PREFIX} cmake --install build
```

### 5. Build using CMake workflows (optional)

To configure, build and install at once, using a cmake workflow preset, do the following:

```shell
# Your KDE_PREFIX variable must match your KDE instalation (eg. KDE_PREFIX=/usr/local)
KDE_PREFIX=$(pkg-config --variable=prefix KF6CoreAddons 2>/dev/null || echo "/usr/local")

if [ $(id -u) -eq 0 ]; then
    export PREFIX="${KDE_PREFIX}"
    CMD_PREFIX="PREFIX=${PREFIX} sudo -E"
else
    export PREFIX="$HOME/.local"
    CMD_PREFIX=""
fi

${CMD_PREFIX} cmake --workflow --preset default-workflow --fresh
```

***
