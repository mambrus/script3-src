#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $MGREP_SH ]; then

MGREP_SH="mgrep.sh"

# Attempts to work as the very useful Android cgrep utility

XGREP_PATTERN='\(.*\.scons$\|.*\.mk$\|.*makefile.*$\|.*SConscript$\|.*SConstruct$\|.*\.min$\|.*configure.in\)'


source s3.ebasename.sh
source src.xgrep.sh
if [ "$MGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${MGREP_SH}
	source .src.ui..xgrep.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
else
	echo "Don't source $XGREP_SH_INFO"
fi

fi
