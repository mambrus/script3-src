#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-20
# This is the backend for all src.*grep.sh tools. All it needs is a pattern
# in the envvar XGREP_PATTERN. If run as from-end, it will search for
# everything (which is basically equal to the normal egrep)

if [ -z $XGREP_SH ]; then

XGREP_SH="xgrep.sh"

function xgrep() {
	if [ "X${XGREP_PATTERN}" == "X" ]; then
		XGREP_PATTERN='\(.*\)'
	fi

	find . -iregex "${XGREP_PATTERN}" -exec egrep "${1}" -nH "${2}" '{}' ';'
}


source s3.ebasename.sh
if [ "$XGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${XGREP_SH}
	source src.ui.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
