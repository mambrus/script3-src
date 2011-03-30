#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $CGREP_SH ]; then

CGREP_SH="cgrep.sh"

# Atempts to work as the very useful Android cgrep utility

function cgrep() {
	find . -iregex '\(.*\.c$\|.*\.h$\|.*\.s$\)' -exec egrep "$1" --color=always -nH '{}' ';' \
	| grcat conf.gcc
}

source s3.ebasename.sh
if [ "$CGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	cgrep $@
	exit $?
fi

fi
