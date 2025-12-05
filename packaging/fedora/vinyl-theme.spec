%bcond_with git
%bcond mozilla 0

%global srcname	vinyl

# Build a git snapshot
%if 0%{?with_git:1}
%define git	58cedc2932f780f8cc81c479b7b87f777a83e5ce
%define gitrev	%(echo %{git} | cut -b 1-7)
%endif

Name:           %{srcname}-theme
Version:        6.5.3
Release:        1%{?git:+git~%{gitrev}}%{?dist}
Summary:        A modern style for qt applications

License:        GPLv2+ and MIT
URL:            https://github.com/ekaaty/vinyl-theme
%if 0%{?git:1} > 0
Source0:        %url/archive/%{gitrev}.tar.gz#/%{srcname}-git~%{gitrev}.tar.gz
%else
Source0:        %url/archive/v%{version}/%{srcname}-%{version}.tar.xz
%endif

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

Provides:       Plasma(ColorScheme-Vinyl-Dark)
Provides:       Plasma(ColorScheme-Vinyl-Light)
Provides:       Plasma(CursorTheme-Vinyl-Black)
Provides:       Plasma(CursorTheme-Vinyl-White)
Provides:       Plasma(DesktopTheme-Vinyl)
Provides:       Plasma(GlobalTheme-Vinyl-Dark)
Provides:       Plasma(GlobalTheme-Vinyl-Light)
Provides:       Plasma(IconTheme-Vinyl)
Provides:       Plasma(KonsoleTheme-Vinyl)
Provides:       Plasma(LayoutTemplates-Vinyl)
Provides:       Plasma(MenuLauncher-Vinyl)
Provides:       Plasma(SDDMTheme-Vinyl)
Provides:       Plasma(Splash-Vinyl)
Provides:       Plasma(WidgetStyle-Vinyl)
Provides:       Plasma(Wallpapers-Vinyl)
Provides:       Plasma(WindowDecoration-Vinyl)

%if %{with mozilla}
Provides:       Mozilla(FirefoxTheme-Vinyl-Dark)
Provides:       Mozilla(FirefoxTheme-Vinyl-Light)
%endif

# Prevent issue github #29 on Fedora
Requires:       kdeplasma-addons

%description
Vinyl is a fork of Lightly (a Breeze fork) theme style that aims to be
visually modern and minimalistic.

%prep
%if 0%{?git:1} > 0
%setup -n %{srcname}-%{git}
%else
%setup -n %{srcname}-%{version}
%endif

%cmake_kf6

pushd cursors
  cp AUTHORS ../AUTHORS.cursors
  cp COPYING ../COPYING.cursors
  cp LICENSE ../LICENSE.cursors
  cp README.md ../README.cursors.md
popd


%build
%cmake_build


%install
%cmake_install \
  --prefix %{_prefix}

for variant in Black White; do
    if [ -d cursors/Vinyl-${variant} ]; then
        %{__mkdir_p} %{buildroot}%{_datadir}/icons/Vinyl-${variant} && \
        %{__cp} -av cursors/Vinyl-${variant}/* \
            %{buildroot}%{_datadir}/icons/Vinyl-${variant}/
    fi
done

%files
%license LICENSES/
%doc AUTHORS.md COPYING.md README.md

# Application style
%{_bindir}/vinyl-settings6
%{_datadir}/kstyle/themes/vinyl.themerc
%{_qt6_plugindir}/kstyle_config/vinylstyleconfig.so
%{_qt6_plugindir}/styles/vinyl6.so
%{_libdir}/cmake/Vinyl/

# Window Decoration
%{_qt6_plugindir}/org.kde.kdecoration3/org.kde.vinyl.so
%{_qt6_plugindir}/org.kde.kdecoration3.kcm/kcm_vinyldecoration.so
%{_datadir}/applications/kcm_vinyldecoration.desktop

# Colors
%{_datadir}/color-schemes/Vinyl*Dark.colors
%{_datadir}/color-schemes/Vinyl*Light.colors

# Splash
%{_datadir}/locale/*/*/plasma_lookandfeel_*.vinyl-splash.mo
#{_datadir}/metainfo/*.vinyl-splash.appdata.xml
%{_datadir}/plasma/look-and-feel/*vinyl-splash/

# Launcher
%{_datadir}/locale/*/*/plasma_applet_*.vinyl-launcher.mo
#{_datadir}/metainfo/*.vinyl-launcher.appdata.xml
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
#{_datadir}/metainfo/*.vinyl.desktop.bottomPanel.appdata.xml

# Global Themes
%{_datadir}/plasma/look-and-feel/*vinyl.desktop.*
#{_datadir}/metainfo/*.vinyl.desktop.dark.appdata.xml
#{_datadir}/metainfo/*.vinyl.desktop.light.appdata.xml

# Mozilla Firefox Themes
%if %{with mozilla}
%{_datadir}/mozilla/extensions/*
%endif

# SDDM Theme
%{_datadir}/locale/*/*/sddm_theme_*.vinyl-sddm.mo
%{_datadir}/sddm/themes/*

# Wallpapers
%{_datadir}/wallpapers/Vinyl*

%changelog
* Fri Dec 05 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.5.3-1
- new release: v6.5.3
- cmake: fixes for extra modules >= 6.20.0
- launcher: fixed issue with panel autohide (#53)

* Sun Nov 09 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.5.2-1
- new release: v6.5.2
- launcher: fixed session icons (#47)

* Mon Nov 03 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.5.1-1
- new release: v6.5.1
- icons: use original Ekaaty colors
- kstyle:
 - fixed gwenview border radius (#32)
 - fixed drag and drop (#37)
 - adjusted widget default sizes

* Thu Oct 23 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.5.0-1
- new release: v6.5.0
- desktoptheme:
  - appearance enhancements and fixes
- icons:
  - fixed firefox icons
  - fixed virt-manager icon
- launcher:
  - refactored based on current Kicker
  - added support for menu variants
  - fix crash in Plasma 6.5.0
- look-and-feel:
  - disabled day/night switch applet
- wallpapers:
  - removed Vinyl:Tracks
  - added Vinyl:Stripes

* Tue Sep 09 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.4.5-1
- new release: v6.4.5
- colors: added green, orange, red and yellow variants
- cursors: replaced inkscape depedency by python3-{cairosvg,lxml}
- desktoptheme: fix slider size
- icons: 
  - added start-here-ekaaty icon
  - updated kde_connect, shodo and firefox icons
- kdecoration:
  - added a Klassy theme for Vinyl
  - backports from breeze 6.4.80
- konsole: updated experimental profile auto-update script
- kstyle: 
  - Updated config UI
  - backports from breeze 6.4.80
  - Fix menu transparency effect glitched (#22)
- launcher: korean translation
- layout-templates: added bottom panel template
- look-and-feel: added early dark/light themes

* Wed Aug 20 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.4.4-1
- new release: v6.4.4
- Bug fix: fix build on Debian 13 (github #20)
- icons: added firefox-nightly and firefox-developer icons (github #19)

* Thu Aug 07 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.4.3-1
- konsole: added initial profile and color schemes for Konsole
- mozilla: added initial themes for Firefox
- sddm: added initial theme

* Wed Mar 05 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.3.2-1
- colors: Removed Light and Dark in favor of 4 new color schemes
- desktoptheme: added initial theme
- kdecoration: updated to use Kdecoration3
- kstyle: Bug fix: Corner Bug (github #6)
- wallpapers: added "Tracks" theme

* Thu Feb 13 2025 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.3.0-1
- new version for Plasma 6.3.0 
- Bug fix: Vinyl Theme Broken On Plasma 6.3 (github #12)
- decoration is disabled for now (API broken)

* Tue Nov 19 2024 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.2.3-1
- updated to 6.2.3
- added icons

* Tue Oct 08 2024 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.1.6-1
- updated to 6.1.6

* Wed Oct 02 2024 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.1.5-1
- Added splash and menu launcher
- translations updates

* Thu Mar 21 2024 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 6.0.2-1
- Plasma 6 version

* Wed Jan 17 2024 Christian Tosta <7252968+christiantosta@users.noreply.github.com> - 0.5.0-1
- Initial build
