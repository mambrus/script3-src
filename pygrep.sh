#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-09-27

if [ -z $PYGREP_SH ]; then

PYGREP_SH="pygrep.sh"

# Attempts to work as the very useful Android cgrep utility

XGREP_FIND_RE='\(.*\.py$\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$PYGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${PYGREP_SH}
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
