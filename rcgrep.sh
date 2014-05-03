#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-27

if [ -z $RCGREP_SH ]; then

RCGREP_SH="rcgrep.sh"

# Attempts to work as the very useful Android cgrep utility but
# for *.rc files (preferably init's but script can't see the difference
# right now)

function rcgrep() {
	XGREP_PATTERN='\(.*\.rc\)'
	xgrep "${1}" "${2}"
}


source s3.ebasename.sh
source src.xgrep.sh
if [ "$RCGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${RCGREP_SH}
	source .src.ui..xdir.sh

	rcgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
