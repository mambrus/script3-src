#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $CGREP_SH ]; then

CGREP_SH="cgrep.sh"

# Attempts to work as the very useful Android cgrep utility

XGREP_PATTERN='\(.*\.c$\|.*\.cpp$\|.*\.h$\|.*\.s$\|.*\.ld$\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$CGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${CGREP_SH}
	source .src.ui..xgrep.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
else
	echo "Don't source $XGREP_SH_INFO"
fi

fi
