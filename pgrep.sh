#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-27

if [ -z $PGREP_SH ]; then

PGREP_SH="pgrep.sh"

# Attempts to work as the very useful Android cgrep utility but
# for Android property-files

XGREP_PATTERN='\(.*\.prop\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$PGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${PGREP_SH}
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
