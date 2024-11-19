#!/bin/sh
set -eu -o pipefail

curdir=$(dirname $(realpath -e ${0}))
# Set the name of your cursor theme
themetitle=${themetitle:-'Vinyl'}

# For the folder name: Replace forbidden charakters with “-”
themefolder=${curdir}/build/$(echo $themetitle | sed -e 's/[^A-Za-z0-9_-]/-/g')

rm -rf ${themefolder}
mkdir -p ${themefolder}
cp -a ${curdir}/src/{actions,apps,places,index.theme} ${themefolder}/

# Create symbolic links
for f in $(find ${themefolder}/ -name links.txt -not -empty); do
	dir=$(dirname $(realpath -e ${f}))
	file=$(basename $(realpath -e ${f}))
	cd ${dir} && \
	  echo Entering ${dir} && \
	  cat ${file} | xargs -n2 ln -svnf
	rm -f ${file}
	cd - >/dev/null 2>&1 
done
