#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-04-02

if [ -z $AUTOGREP_SH ]; then

AUTOGREP_SH="autogrep.sh"

#Attempts to help greping in autmake-tool config files

function autogrep() {
	local PATTERN='\(.*\.m4$\|.*\.in\|.*\.ac$\)'
	find . -iregex "${PATTERN}" -exec egrep "$1" -nH --color=always '{}' ';' | \
		grcat conf.gcc
}

source s3.ebasename.sh
if [ "$AUTOGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	autogrep $@
	exit $?
fi

fi
