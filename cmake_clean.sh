#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2016-01-29

if [ -z $CMAKE_CLEAN_SH ]; then

CMAKE_CLEAN_SH="cmake_clean.sh"

## Remove everything matching pattern passed as argument, regardless of it
## is a file or a directory.
function cmake_clean_find_remove() {
	SRCH_PATT="${1}"
	for F in $(find . -name ${SRCH_PATT}); do
		echo "${F}";
		rm -rf "${F}";
	done
}

function cmake_clean() {
	pushd "${CMAKE_CLEAN_FIND_DIR}" > /dev/null
		cmake_clean_find_remove 'CMakeCache.txt'
		cmake_clean_find_remove 'CMakeFiles'

		cmake_clean_find_remove 'cmake_install.cmake'
		cmake_clean_find_remove 'config.h'
		cmake_clean_find_remove 'Makefile'
	popd > /dev/null
}

source s3.ebasename.sh
if [ "$CMAKE_CLEAN_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	CMAKE_CLEAN_SH_INFO=${CMAKE_CLEAN_SH}
	source .src.ui..cmake_clean.sh

	cmake_clean "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
