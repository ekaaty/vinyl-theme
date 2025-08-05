#!/usr/bin/env sh 

cd ${PWD}
metadata="src/metadata.desktop"

AUTHOR="$(grep -iPo 'Author=\K[^=]*' ${metadata})"
EMAIL="$(grep -iPo 'Email=\K[^=]*' ${metadata})"
YEAR="$(date +%Y)"
BUG_REPORT_URL="https://github.com/ekaaty/vinyl-theme/issues"
DESCRIPTION="$(grep -iPo 'Description=\K[^=]*' ${metadata})"
PACKAGE="$(grep -iPo 'Name=\K[^=]*' ${metadata}) SDDM Theme"
VERSION="$(grep -iPo 'Version=\K[^=]*' ${metadata})"

EXTOPTS="--c++ --kde \
    --from-code=UTF-8 \
    -ci18n \
    -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 \
    -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
    -kkli18n:1 -kkli18nc:1c,2 -kkli18np:1,2 -kkli18ncp:1c,2,3 \
    -kI18N_NOOP:1 -kI18NC_NOOP:1c,2 -kQT_TR_NOOP:1"

mkdir -p po
find src/ -name \*.qml -o -name \*.js -o -name \*.cpp | sort \
    | xargs xgettext ${EXTOPTS} \
    --package-name="${PACKAGE}" \
    --package-version="${VERSION}" \
    --copyright-holder="${AUTHOR}" \
    --msgid-bugs-address="${BUG_REPORT_URL}" \
    -o po/template.pot

sed -i \
    -e "s/SOME DESCRIPTIVE TITLE./${DESCRIPTION}/" \
    -e "s/FIRST AUTHOR <EMAIL@ADDRESS>/${AUTHOR} <${EMAIL}>/" \
    -e "s/^#\(.*\)YEAR/#\1${YEAR}/" \
    po/template.pot

exit $?
