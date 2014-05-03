#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-04-02

if [ -z $SHGREP_SH ]; then

SHGREP_SH="shgrep.sh"

XGREP_PATTERN='\(.*\.sh$\|.*\.exp$\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$SHGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${SHGREP_SH}
	source .src.ui..xdir.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
else
	echo "Don't source $XGREP_SH_INFO"
fi

fi
