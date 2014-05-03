#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-20
# This is the back-end for all src.*grep.sh tools. All it needs is a pattern
# in the envvar XGREP_PATTERN. If run as front-end, it will search for
# everything (which is basically equal to the normal egrep)

if [ -z $XGREP_SH ]; then

XGREP_SH="xgrep.sh"

function xgrep() {
	if [ "X${XGREP_PATTERN}" == "X" ]; then
		echo "Warning: XGREP_PATTERN is unset. Assigning default" 2>&1
		XGREP_PATTERN='\(.*\)'
	fi

	if [ "X${IGNORE_CAP}" == "XNO" ]; then
		find ${XGREP_FIND_EXTRAS} . \
			"${XGREP_IGNORE_PATH}" \
			-regex "${XGREP_PATTERN}" \
			-type f \
			-exec egrep ${XGREP_GREP_EXTRAS} "${1}" -nH "${2}" '{}' ';'
	else
		#Note: This execution path is the default
		find ${XGREP_FIND_EXTRAS} . \
			"${XGREP_IGNORE_PATH}" \
			-iregex "${XGREP_PATTERN}" \
			-type f \
			-exec egrep ${XGREP_GREP_EXTRAS} "${1}" -nH "${2}" '{}' ';'
	fi
}


source s3.ebasename.sh
if [ "$XGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${XGREP_SH}
	source .src.ui..xdir.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
