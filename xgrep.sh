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
		XGREP_PATTERN='\(.*\)'
	fi

	if [ "X${IGNORE_CAP}" == "XNO" ]; then
		find ${XGREP_FIND_EXTRAS} . \
			-path "./out*" -prune -o \
			-path "./.repo/" -prune -o \
			-path "*/.git/*" -prune -o \
			-regex "${XGREP_PATTERN}" \
			-exec egrep ${XGREP_GREP_EXTRAS} "${1}" -nH "${2}" '{}' ';'
	else
		find ${XGREP_FIND_EXTRAS} . \
			-path "./out*" -prune -o \
			-path "./.repo/" -prune -o \
			-path "*/.git/*" -prune -o \
			-iregex "${XGREP_PATTERN}" \
			-exec egrep -i ${XGREP_GREP_EXTRAS} "${1}" -nH "${2}" '{}' ';'
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
#		find "${XGREP_FIND_EXTRAS}" . \
