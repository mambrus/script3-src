#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-04-02

if [ -z $AUTOGREP_SH ]; then

AUTOGREP_SH="autogrep.sh"

#Attempts to help greping in autmake-tool config files

PATTERN='\(.*\.m4$\|.*\.in\|.*\.ac$\)'

source src.xgrep.sh
source s3.ebasename.sh
if [ "$AUTOGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${AUTOGREP_SH}
	source .src.ui..xdir.sh

	xgrep "$@" "${COLOR_PARAM}"
	exit $?
else
	echo "Don't source $XGREP_SH_INFO"
fi

fi
