#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $JGREP_SH ]; then

JGREP_SH="jgrep.sh"

# Atempts to work as the very useful Android jgrep utility

function jgrep() {
	find . -iregex '\(.*\.java$\|.*makefile.*$\)' -exec egrep "$1" -nH --color=always '{}' ';' \
	| grcat conf.gcc
}

source s3.ebasename.sh
if [ "$JGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	jgrep $@
	exit $?
fi

fi
