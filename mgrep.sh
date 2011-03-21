#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $MGREP_SH ]; then

MGREP_SH="mgrep.sh"

# Atempts to work as the very useful Android mgrep utility

function mgrep() {
	find . -iregex '\(.*\.mk$\|.*makefile.*$\)' -exec egrep "$1" -nH '{}' ';' \
	| grcat conf.gcc
}

source s3.ebasename.sh
if [ "$MGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	mgrep $@
	exit $?
fi

fi
