#!/usr/bin/env bash

# A script to build a debian package inside Kubuntu and Neon docker containers

# Decompress tarball
# Build
# Create package

TARBALL=$1
VERSION=$2
STAGING_DIR="$(pwd)/vinyl-package"
BUILD_DIR="build_kf6"
STYLE="vinyl"
_STYLE="Vinyl"
MAINTAINER="DeltaCopy <7x0bb03yq@mozmail.com>"
PACKAGE_NAME="${STYLE}-theme"
BUILD_ROOT="$(pwd)/${PACKAGE_NAME}-${VERSION}"

test ! -f "$TARBALL" && echo "Tarball doesn't exist" && exit 1
test -z "$VERSION" && echo "Version cannot be empty" && exit 1

prep() {
    if [ -d "$STAGING_DIR" ]; then
        rm -r "$STAGING_DIR"
    fi

    mkdir "$STAGING_DIR"

    cp $TARBALL $STAGING_DIR

    if [ -d "$BUILD_ROOT" ]; then
        rm -r "$BUILD_ROOT"
    fi

    mkdir "$BUILD_ROOT"

}

build() {
    if [ -f "$STAGING_DIR/$TARBALL" ]; then
        cd "$STAGING_DIR"
        tar xvf $TARBALL

        src_dir=$(find . -maxdepth 1 -type d | tail -1)

        echo "$STAGING_DIR/$src_dir" >.srcdir

        # Patch icons CMakeLists to use sh execution since it fails with set: Illegal option -o pipefail on debian hosts

        sed -i s/'COMMAND sh ${CMAKE_CURRENT_SOURCE_DIR}\/make-theme.sh/COMMAND bash ${CMAKE_CURRENT_SOURCE_DIR}\/make-theme.sh/' "$src_dir/icons/CMakeLists.txt"

        # Patch cursors/Render.make it generates the index.theme file with invalid '-e [Index Theme]' to the index.theme

        sed -i s/'echo -e/echo/' "$src_dir/cursors/Render.make"

        cmake_opts=(
            -B $STAGING_DIR/$BUILD_DIR
            -S .
        )

        cd "$STAGING_DIR/$src_dir"

        cmake "${cmake_opts[@]}" && cmake --build $STAGING_DIR/$BUILD_DIR -j$(nproc) && cd $STAGING_DIR/$BUILD_DIR && sudo cmake --install . --prefix /usr && echo "Installation completed!" && pkgsetup && pkgbuild || echo "Installation failed!" && exit 1

    else
        echo "Error $STAGING_DIR directory doesn't exist."
        exit 1
    fi
}

pkgsetup() {

    # make staging directory for pkgbuild

    test ! -f "$STAGING_DIR/$BUILD_DIR/install_manifest.txt" && echo "install_manifest.txt is missing, did the theme build successfully ?" && exit 1
    
    echo "Creating debian package directory structure."

    cd "$BUILD_ROOT"

    # dpkg dir setup

    while read line; do
        mkdir -p $BUILD_ROOT$(dirname "$line")
    done <"$STAGING_DIR/$BUILD_DIR/install_manifest.txt"

    # docs

    mkdir -p ./usr/share/doc/${STYLE}-theme

    _srcdir=$(cat $STAGING_DIR/.srcdir)
    _bindir="/usr/bin"
    _datadir="/usr/share"
    _kf6_plugindir="/usr/lib/x86_64-linux-gnu/qt6/plugins"
    _libdir="/usr/lib/x86_64-linux-gnu"
    
    # application style
    cp -a $STAGING_DIR/$BUILD_DIR/bin/${STYLE}-settings6 $BUILD_ROOT/$_bindir
    cp -a $_srcdir/kstyle/$STYLE.themerc $BUILD_ROOT/$_datadir/kstyle/themes

    cp -a $STAGING_DIR/$BUILD_DIR/bin/kstyle_config/${STYLE}styleconfig.so $BUILD_ROOT/$_kf6_plugindir/kstyle_config/vinylstyleconfig.so
    cp -a $STAGING_DIR/$BUILD_DIR/bin/${STYLE}6.so $BUILD_ROOT/$_kf6_plugindir/styles

    # color-schemes
    cp -a $_srcdir/colors/src/${_STYLE}*Dark.colors $BUILD_ROOT/$_datadir/color-schemes
    cp -a $_srcdir/colors/src/${_STYLE}*Light.colors $BUILD_ROOT/$_datadir/color-schemes


    # windows decoration
    cp -a $STAGING_DIR/$BUILD_DIR/bin/org.kde.kdecoration3.kcm/kcm_${STYLE}decoration.so $BUILD_ROOT/$_kf6_plugindir/org.kde.kdecoration3.kcm
    cp -a $STAGING_DIR/$BUILD_DIR/bin/org.kde.${STYLE}.so $BUILD_ROOT/$_kf6_plugindir/org.kde.kdecoration3

    # splash screen
    cp -ra $_srcdir/splash/src/package/* $BUILD_ROOT/$_datadir/plasma/look-and-feel/com.ekaaty.${STYLE}-splash
    
    # cmake config files
    cp -a $STAGING_DIR/$BUILD_DIR/${_STYLE}Config.cmake $BUILD_ROOT/$_libdir/cmake/${_STYLE}
    cp -a $STAGING_DIR/$BUILD_DIR/${_STYLE}ConfigVersion.cmake $BUILD_ROOT/$_libdir/cmake/${_STYLE}
    
    
    # locales
    cp -ra $STAGING_DIR/$BUILD_DIR/splash/locale/* $BUILD_ROOT/$_datadir/locale
    cp -ra $STAGING_DIR/$BUILD_DIR/plasma/plasmoids/launcher/locale/* $BUILD_ROOT/$_datadir/locale
    cp -ra $STAGING_DIR/$BUILD_DIR/sddm/locale/* $BUILD_ROOT/$_datadir/locale
    
    # konsole profile and color-schemes
    cp -ra $_srcdir/konsole/src/* $BUILD_ROOT/$_datadir/konsole
    
    # launcher plasmoid
    cp -ra $_srcdir/plasma/plasmoids/launcher/src/package/contents $BUILD_ROOT/$_datadir/plasma/plasmoids/com.ekaaty.${STYLE}-launcher
    cp -a $_srcdir/plasma/plasmoids/launcher/src/package/metadata.json $BUILD_ROOT/$_datadir/plasma/plasmoids/com.ekaaty.${STYLE}-launcher

    # plasma desktop theme
    cp -ra $_srcdir/plasma/desktoptheme/src/* $BUILD_ROOT/$_datadir/plasma/desktoptheme/com.ekaaty.${STYLE}-plasma

    # plasma look-and-feel
    cp -ra $_srcdir/plasma/look-and-feel/*${STYLE}.desktop.light $BUILD_ROOT/$_datadir/plasma/look-and-feel
    cp -ra $_srcdir/plasma/look-and-feel/*${STYLE}.desktop.dark $BUILD_ROOT/$_datadir/plasma/look-and-feel
    
    # plasma layout-templates
    cp -ra $_srcdir/plasma/layout-templates/com.ekaaty.${STYLE}.desktop.bottomPanel $BUILD_ROOT/$_datadir/plasma/layout-templates

    # sddm
    cp -ra $_srcdir/sddm/src/* $BUILD_ROOT/$_datadir/sddm/themes/com.ekaaty.${STYLE}-sddm

    # wallpapers
    cp -ra $_srcdir/wallpapers/src/* $BUILD_ROOT/$_datadir/wallpapers

    cp -a $STAGING_DIR/$BUILD_DIR/kdecoration/config/kcm_${STYLE}decoration.desktop $BUILD_ROOT/$_datadir/applications

    # cursors
    for _variant in Black White; do
        if [ -d $_srcdir/cursors/build/${_STYLE}-${_variant} ]; then
            cp -a $_srcdir/cursors/build/${_STYLE}-${_variant}/* $BUILD_ROOT/$_datadir/icons/${_STYLE}-${_variant}/
        fi
    done

    # icons

    for _asset in actions apps places; do
        if [ -d $_srcdir/icons/build/${_STYLE}/${_asset} ]; then
            cp -ra $_srcdir/icons/build/${_STYLE}/${_asset} $BUILD_ROOT/$_datadir/icons/${_STYLE}
        fi
    done

    cp -a $_srcdir/icons/build/${_STYLE}/index.theme $BUILD_ROOT/$_datadir/icons/${_STYLE}

    # docs

    cp -a $_srcdir/cursors/AUTHORS ./usr/share/doc/${STYLE}-theme/AUTHORS.cursors
    cp -a $_srcdir/cursors/README.md ./usr/share/doc/${STYLE}-theme/README.cursors.md

    cp -a $_srcdir/AUTHORS.md ./usr/share/doc/${STYLE}-theme
    cp -a $_srcdir/COPYING.md ./usr/share/doc/${STYLE}-theme
    cp -a $_srcdir/README.md ./usr/share/doc/${STYLE}-theme

    mkdir DEBIAN
    cat <<EOF >DEBIAN/control
Package: ${PACKAGE_NAME}
Maintainer: ${MAINTAINER}
Section: kde
Version: ${VERSION}
Priority: optional
Architecture: amd64
Description: Vinyl is a fork of Lightly (a Breeze fork) theme style that aims to be visually modern and minimalistic.
EOF

}

pkgbuild() {
    echo "Running dpkg-deb."
    cd "$GITHUB_WORKSPACE"
    dpkg-deb --root-owner-group --build ${PACKAGE_NAME}-${VERSION}

    test $? -eq 0 && echo "Package build successful" && exit 0 || echo "Package build failed." || exit 1

}

run() {
    prep
    build
}

run
