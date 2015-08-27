#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2015-06-08

if [ -z $DTGREP_SH ]; then

DTGREP_SH="dtgrep.sh"

XGREP_FIND_RE='\(.*\.dts$\|.*\.dtsi$\)'


source s3.ebasename.sh
source src.xgrep.sh
if [ "$DTGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${DTGREP_SH}
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
