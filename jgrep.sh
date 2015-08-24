#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $JGREP_SH ]; then

JGREP_SH="jgrep.sh"

XGREP_PATTERN='\(.*\.java$\|.*makefile.*$\|.*\.xml$\)'


source s3.ebasename.sh
source src.xgrep.sh
if [ "$JGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${JGREP_SH}
	XGREP_IGNORE=${XGREP_IGNORE-'
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
