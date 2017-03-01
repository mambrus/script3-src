#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2017-03-01

if [ -z $CSGREP_SH ]; then

CSGREP_SH="csgrep.sh"

# Attempts to work as the very useful Android csgrep utility

XGREP_FIND_RE='\(.*\.cs$\|.*\.CS$\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$CSGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${CSGREP_SH}
	XGREP_FIND_IGNORE=${XGREP_FIND_IGNORE-'
		-path ./out* -prune -o
		-path ./.repo/ -prune -o
		-path "*/.git/" -prune -o '}
	source .src.ui..xgrep.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
else
	echo "Don't source $XGREP_SH_INFO"
fi

fi
