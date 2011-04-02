#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-04-02

if [ -z $SHGREP_SH ]; then

SHGREP_SH="shgrep.sh"

function shgrep() {
	local PATTERN='\(.*\.sh$\|.*\.exp$\)'
	find . -iregex "${PATTERN}" -exec egrep "$1" -nH --color=always '{}' ';' | \
		grcat conf.gcc
}

source s3.ebasename.sh
if [ "$SHGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	shgrep $@
	exit $?
fi

fi
