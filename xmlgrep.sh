#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2017-03-01

if [ -z $XMLGREP_SH ]; then

XMLGREP_SH="xmlgrep.sh"

# Attempts to work as the very useful Android xmlgrep utility

XGREP_FIND_RE='\(.*\.xml$\|.*\.XML$\)'

source s3.ebasename.sh
source src.xgrep.sh
if [ "$XMLGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${XMLGREP_SH}
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
