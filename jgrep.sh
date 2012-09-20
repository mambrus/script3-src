#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $JGREP_SH ]; then

JGREP_SH="jgrep.sh"

function jgrep() {
	XGREP_PATTERN='\(.*\.java$\|.*makefile.*$\)'
	xgrep "${1}" "${2}"
}


source s3.ebasename.sh
source src.xgrep.sh
if [ "$JGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${JGREP_SH}
	source src.ui.sh

	jgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
