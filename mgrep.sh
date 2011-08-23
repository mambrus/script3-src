#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $MGREP_SH ]; then

MGREP_SH="mgrep.sh"

# Atempts to work as the very useful Android mgrep utility
# Note that for Scons dependency files (SConscript, SConstruct, *.min), I don't know where the convention of
# putting these dependencies into *.min comes from. It might not be standard.
function mgrep() {
	find . -iregex '\(.*\.mk$\|.*makefile.*$\|.*SConscript$\|.*SConstruct$\|.*\.min$\)' -exec egrep "$1" -nH --color=always '{}' ';' \
	| grcat conf.gcc
}

source s3.ebasename.sh
if [ "$MGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	mgrep $@
	exit $?
fi

fi
