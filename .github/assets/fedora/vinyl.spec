%global style vinyl
%global _style Vinyl
%define dev ekaaty
%define release_tag ${TAG} # this line gets updated automatically by Github Actions

Name:           %{style}-theme
Version:        %{release_tag}
Release:        0
Summary:        A modern style for qt applications

License:        GPLv2+ and MIT

# Build a git snapshot
URL:            https://github.com/%{dev}/%{style}-theme
Source0:        https://github.com/archive/v%{version}/%{style}-%{version}.tar.gz

BuildRequires:  cmake
BuildRequires:  cmake(KDecoration3)
BuildRequires:  cmake(KF6ConfigWidgets)
BuildRequires:  cmake(KF6Config)
BuildRequires:  cmake(KF6CoreAddons)
BuildRequires:  cmake(KF6Crash)
BuildRequires:  cmake(KF6DocTools)
BuildRequires:  cmake(KF6FrameworkIntegration)
BuildRequires:  cmake(KF6GlobalAccel)
BuildRequires:  cmake(KF6GuiAddons)
BuildRequires:  cmake(KF6I18n)
BuildRequires:  cmake(KF6IconThemes)
BuildRequires:  cmake(KF6KCMUtils)
BuildRequires:  cmake(KF6KIO)
BuildRequires:  cmake(KF6Notifications)
BuildRequires:  cmake(KF6Package)
BuildRequires:  cmake(KF6WindowSystem)
BuildRequires:  cmake(KF6KirigamiPlatform)
BuildRequires:  cmake(KWayland)
BuildRequires:  cmake(KWin)
BuildRequires:  cmake(Plasma)
BuildRequires:  cmake(Qt6Core)
BuildRequires:  cmake(Qt6Core5Compat)
BuildRequires:  cmake(Qt6DBus)
BuildRequires:  cmake(Qt6Gui)
BuildRequires:  cmake(Qt6UiTools)
BuildRequires:  pkgconfig(epoxy)
BuildRequires:  python3dist(cairosvg)
BuildRequires:  python3dist(lxml)
BuildRequires:  extra-cmake-modules >= 6.13.0
BuildRequires:  gcc-c++
BuildRequires:  git-core
BuildRequires:  xcursorgen
BuildRequires:  unzip
BuildRequires:  fdupes

Provides:       Plasma(ColorScheme-Vinyl-Dark)
Provides:       Plasma(ColorScheme-Vinyl-Light)
Provides:       Plasma(CursorTheme-Vinyl-Black)
Provides:       Plasma(CursorTheme-Vinyl-White)
Provides:       Plasma(DesktopTheme-Vinyl)
Provides:       Plasma(KonsoleTheme-Vinyl)
Provides:       Plasma(IconTheme-Vinyl)
Provides:       Plasma(MenuLauncher-Vinyl)
Provides:       Mozilla(FirefoxTheme-Vinyl-Dark)
Provides:       Mozilla(FirefoxTheme-Vinyl-Light)
Provides:       Plasma(SDDMTheme-Vinyl)
Provides:       Plasma(Splash-Vinyl)
Provides:       Plasma(WidgetStyle-Vinyl)
Provides:       Plasma(Wallpapers-Vinyl)
Provides:       Plasma(WindowDecoration-Vinyl)


# Prevent issue github #29 on Fedora
%if 0%{?fedora} || 0%{?centos_version} || 0%{?rhel_version}
Requires:      kdeplasma-addons
%endif


%description
Vinyl is a fork of Lightly (a Breeze fork) theme style that aims to be
visually modern and minimalistic.

%prep
%setup -n %{name}-%{version}

%if 0%{?fedora}
%cmake_kf6
%endif

pushd cursors
  cp AUTHORS ../AUTHORS.cursors
  cp COPYING ../COPYING.cursors
  cp LICENSE ../LICENSE.cursors
  cp README.md ../README.cursors.md
popd

%build
%cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DKDE_INSTALL_USE_QT_SYS_PATHS=ON
%cmake_build -j $(nproc)

%install
%if 0%{?is_opensuse}
mkdir -p %{buildroot}%{_kf6_bindir}
mkdir -p %{buildroot}%{_datadir}/kstyle/themes
mkdir -p %{buildroot}%{_datadir}/color-schemes
mkdir -p %{buildroot}%{_datadir}/locale
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}/%{_kf6_plugindir}/styles
mkdir -p %{buildroot}/%{_kf6_plugindir}/org.kde.kdecoration3
mkdir -p %{buildroot}/%{_kf6_plugindir}/org.kde.kdecoration3.kcm
mkdir -p %{buildroot}%{_datadir}/plasma/look-and-feel/com.ekaaty.%{style}-splash
mkdir -p %{buildroot}%{_libdir}/cmake/%{_style}
mkdir -p %{buildroot}%{_datadir}/plasma/plasmoids/com.ekaaty.%{style}-launcher
mkdir -p %{buildroot}%{_datadir}/icons
mkdir -p %{buildroot}%{_datadir}/icons/%{_style}-Black
mkdir -p %{buildroot}%{_datadir}/icons/%{_style}-White
mkdir -p %{buildroot}%{_datadir}/konsole
mkdir -p %{buildroot}%{_datadir}/wallpapers
mkdir -p %{buildroot}%{_datadir}/plasma/desktoptheme/com.ekaaty.%{style}-plasma
mkdir -p %{buildroot}%{_datadir}/plasma/layout-templates
mkdir -p %{buildroot}%{_datadir}/sddm/themes/com.ekaaty.%{style}-sddm

cp -a %{_builddir}/%{name}-%{version}/build/bin/%{style}-settings6 %{buildroot}%{_kf6_bindir}
cp -a %{_builddir}/%{name}-%{version}/kstyle/%{style}.themerc %{buildroot}/%{_datadir}/kstyle/themes
cp -a %{_builddir}/%{name}-%{version}/build/bin/%{style}6.so %{buildroot}/%{_kf6_plugindir}/styles
cp -a %{_builddir}/%{name}-%{version}/colors/src/%{_style}*Dark.colors %{buildroot}/%{_datadir}/color-schemes
cp -a %{_builddir}/%{name}-%{version}/colors/src/%{_style}*Light.colors %{buildroot}/%{_datadir}/color-schemes
cp -a %{_builddir}/%{name}-%{version}/build/bin/org.kde.kdecoration3.kcm/kcm_%{style}decoration.so %{buildroot}/%{_kf6_plugindir}/org.kde.kdecoration3.kcm
cp -a %{_builddir}/%{name}-%{version}/build/bin/org.kde.vinyl.so %{buildroot}/%{_kf6_plugindir}/org.kde.kdecoration3
cp -ra %{_builddir}/%{name}-%{version}/splash/src/package/* %{buildroot}/%{_datadir}/plasma/look-and-feel/com.ekaaty.%{style}-splash
cp -a %{_builddir}/%{name}-%{version}/build/%{_style}Config.cmake %{buildroot}/%{_libdir}/cmake/%{_style}
cp -a %{_builddir}/%{name}-%{version}/build/%{_style}ConfigVersion.cmake %{buildroot}/%{_libdir}/cmake/%{_style}
cp -ra %{_builddir}/%{name}-%{version}/build/splash/locale/* %{buildroot}/%{_datadir}/locale
cp -ra %{_builddir}/%{name}-%{version}/build/plasma/plasmoids/launcher/locale/* %{buildroot}/%{_datadir}/locale
cp -ra %{_builddir}/%{name}-%{version}/build/sddm/locale/* %{buildroot}/%{_datadir}/locale
cp -ra %{_builddir}/%{name}-%{version}/konsole/src/* %{buildroot}/%{_datadir}/konsole
cp -ra %{_builddir}/%{name}-%{version}/plasma/plasmoids/launcher/src/package/contents %{buildroot}/%{_datadir}/plasma/plasmoids/com.ekaaty.%{style}-launcher
cp -a %{_builddir}/%{name}-%{version}/plasma/plasmoids/launcher/src/package/metadata.json %{buildroot}/%{_datadir}/plasma/plasmoids/com.ekaaty.%{style}-launcher
cp -ra %{_builddir}/%{name}-%{version}/plasma/desktoptheme/src/* %{buildroot}/%{_datadir}/plasma/desktoptheme/com.ekaaty.%{style}-plasma
cp -ra %{_builddir}/%{name}-%{version}/plasma/look-and-feel/*%{style}.desktop.light %{buildroot}%{_datadir}/plasma/look-and-feel
cp -ra %{_builddir}/%{name}-%{version}/plasma/look-and-feel/*%{style}.desktop.dark %{buildroot}%{_datadir}/plasma/look-and-feel
cp -ra %{_builddir}/%{name}-%{version}/plasma/layout-templates/com.ekaaty.%{style}.desktop.bottomPanel %{buildroot}/%{_datadir}/plasma/layout-templates
cp -ra %{_builddir}/%{name}-%{version}/sddm/src/* %{buildroot}%{_datadir}/sddm/themes/com.ekaaty.%{style}-sddm
cp -ra %{_builddir}/%{name}-%{version}/wallpapers/src/* %{buildroot}%{_datadir}/wallpapers
cp -ra %{_builddir}/%{name}-%{version}/icons/build/%{_style} %{buildroot}%{_datadir}/icons
cp -a %{_builddir}/%{name}-%{version}/build/kdecoration/config/kcm_%{style}decoration.desktop %{buildroot}%{_datadir}/applications
%endif

%if 0%{?is_opensuse}
%cmake_install
%endif

%if 0%{?fedora}
%cmake_install \
  --prefix %{_prefix}
%endif

%if 0%{?is_opensuse}
for variant in Black White; do
    if [ -d %{_builddir}/%{name}-%{version}/cursors/build/Vinyl-${variant} ]; then
        %{__cp} -av %{_builddir}/%{name}-%{version}/cursors/build/Vinyl-${variant}/* \
            %{buildroot}%{_datadir}/icons/Vinyl-${variant}/
    fi
done
%endif

%if 0%{?fedora}
for variant in Black White; do
    if [ -d cursors/Vinyl-${variant} ]; then
        %{__mkdir_p} %{buildroot}%{_datadir}/icons/Vinyl-${variant} && \
        %{__cp} -av cursors/Vinyl-${variant}/* \
            %{buildroot}%{_datadir}/icons/Vinyl-${variant}/
    fi
done
%endif

%fdupes %{buildroot}/%{_prefix}

%post   -p /sbin/ldconfig
%postun -p /sbin/ldconfig

%files
%if 0%{?is_opensuse}
%exclude %{_builddir}/%{name}-%{version}/build
%endif
%license LICENSES/
%doc AUTHORS.md COPYING.md README.md

# Application style
%if 0%{?is_opensuse}
%{_kf6_bindir}/vinyl-settings6
%{_kf6_plugindir}/kstyle_config/vinylstyleconfig.so
%{_kf6_plugindir}/styles/vinyl6.so
%else
%{_bindir}/vinyl-settings6
%{_qt6_plugindir}/kstyle_config/vinylstyleconfig.so
%{_qt6_plugindir}/styles/vinyl6.so
%endif
#{_datadir}/applications/vinylstyleconfig.desktop
#{_datadir}/icons/hicolor/scalable/apps/vinyl-settings.svg*
%{_datadir}/kstyle/themes/vinyl.themerc
%{_libdir}/cmake/Vinyl/

# Window Decoration
%if 0%{?is_opensuse}
%{_kf6_plugindir}/org.kde.kdecoration3/org.kde.vinyl.so
%{_kf6_plugindir}/org.kde.kdecoration3.kcm/kcm_vinyldecoration.so
%else
%{_qt6_plugindir}/org.kde.kdecoration3/org.kde.vinyl.so
%{_qt6_plugindir}/org.kde.kdecoration3.kcm/kcm_vinyldecoration.so
%endif
%{_datadir}/applications/kcm_vinyldecoration.desktop

# Colors
%{_datadir}/color-schemes/Vinyl*Dark.colors
%{_datadir}/color-schemes/Vinyl*Light.colors

# Splash
%{_datadir}/locale/*/*/plasma_lookandfeel_*.vinyl-splash.mo
%{_datadir}/plasma/look-and-feel/*vinyl-splash/

# Launcher
%{_datadir}/locale/*/*/plasma_applet_*.vinyl-launcher.mo
%{_datadir}/plasma/plasmoids/*vinyl-launcher/

# Cursors
%doc AUTHORS.cursors README.cursors.md
%license COPYING.cursors
%license LICENSE.cursors
%{_datadir}/icons/Vinyl-Black/index.theme
%{_datadir}/icons/Vinyl-Black/cursors/
%{_datadir}/icons/Vinyl-White/index.theme
%{_datadir}/icons/Vinyl-White/cursors/

# Icons
%{_datadir}/icons/Vinyl/

# Konsole
%{_datadir}/konsole/

# Desktop Theme
%{_datadir}/plasma/desktoptheme/*

# Layout Templates
%{_datadir}/plasma/layout-templates/*

# Global Themes
%{_datadir}/plasma/look-and-feel/*vinyl.desktop.*

# Mozilla Firefox Themes
%if %{with mozilla}
%{_datadir}/mozilla/extensions/*
%endif

# SDDM Theme
%{_datadir}/locale/*/*/sddm_theme_*.vinyl-sddm.mo
%{_datadir}/sddm/themes/*

# Wallpapers
%{_datadir}/wallpapers/Vinyl*

%if 0%{?fedora} || 0%{?centos_version} || 0%{?rhel_version}
%changelog
%autochangelog

%else
# OpenSUSE
%changelog

%endif
