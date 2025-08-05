#!/bin/bash

mkdir -p po
lupdate-qt6 \
  src/ \
  -extensions qml \
  -tr-function-alias qsTr=i18n \
  -tr-function-alias qsTranslate=i18nd \
  -ts po/sddm_theme_com.ekaaty.vinyl-sddm.ts \
&& lconvert-qt6 \
  po/sddm_theme_com.ekaaty.vinyl-sddm.ts \
  -o po/sddm_theme_com.ekaaty.vinyl-sddm.pot \
&& rm -f po/sddm_theme_com.ekaaty.vinyl-sddm.ts
