#!/usr/bin/env sh 

cd ${PWD}
metadata=$(cat src/package/metadata.json)

AUTHOR=$(echo ${metadata} | jq .KPlugin.Authors[0].Name | sed 's/"//g')
EMAIL=$(echo ${metadata} | jq .KPlugin.Authors[0].Email | sed 's/"//g')
YEAR="$(date +%Y)"

BUG_REPORT_URL=$(echo ${metadata} | jq .KPlugin.BugReportUrl | sed 's/"//g')
DESCRIPTION=$(echo ${metadata} | jq .KPlugin.Description | sed 's/"//g')
PACKAGE=$(echo ${metadata} | jq .KPlugin.Name | sed 's/"//g')
PACKAGE_ID=$(echo ${metadata} | jq .KPlugin.Id | sed 's/"//g')
PACKAGE_TYPE=$(echo ${metadata} | jq .KPackageStructure | sed 's/\(.*\)/\L\1/;s/\//_/;s/"//g')
VERSION=$(echo ${metadata} | jq .KPlugin.Version | sed 's/"//g')

EXTOPTS="--c++ --kde \
    --from-code=UTF-8 \
    -ci18n \
    -ki18n:1 -ki18nc:1c,2 -ki18np:1,2 -ki18ncp:1c,2,3 \
    -kki18n:1 -kki18nc:1c,2 -kki18np:1,2 -kki18ncp:1c,2,3 \
    -kkli18n:1 -kkli18nc:1c,2 -kkli18np:1,2 -kkli18ncp:1c,2,3 \
    -kI18N_NOOP:1 -kI18NC_NOOP:1c,2 -kQT_TR_NOOP:1"

mkdir -p po
find src/package/ -name \*.qml -o -name \*.js -o -name \*.cpp | sort \
    | xargs xgettext ${EXTOPTS} \
    --package-name="${PACKAGE}" \
    --package-version="${VERSION}" \
    --copyright-holder="${AUTHOR}" \
    --msgid-bugs-address="${BUG_REPORT_URL}" \
    -o po/template.pot
    #-o po/${PACKAGE_TYPE}_${PACKAGE_ID}.pot

sed -i \
    -e "s/SOME DESCRIPTIVE TITLE./${DESCRIPTION}/" \
    -e "s/FIRST AUTHOR <EMAIL@ADDRESS>/${AUTHOR} <${EMAIL}>/" \
    -e "s/^#\(.*\)YEAR/#\1${YEAR}/" \
    po/template.pot

exit $?
