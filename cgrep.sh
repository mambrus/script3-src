#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $CGREP_SH ]; then

CGREP_SH="cgrep.sh"

# Atempts to work as the very useful Android cgrep utility

function cgrep() {
	XGREP_PATTERN='\(.*\.c$\|.*\.h$\|.*\.s$\|.*\.ld$\)'
	xgrep "${1}" "${2}"
}


source s3.ebasename.sh
source src.xgrep.sh
if [ "$CGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${CGREP_SH}
	source .src.ui..xdir.sh

	cgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
