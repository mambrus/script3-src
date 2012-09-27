#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-27

if [ -z $PGREP_SH ]; then

PGREP_SH="pgrep.sh"

# Atempts to work as the very useful Android cgrep utility but
# for property-files

function pgrep() {
	XGREP_PATTERN='\(.*\.prop\)'
	xgrep "${1}" "${2}"
}


source s3.ebasename.sh
source src.xgrep.sh
if [ "$PGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${PGREP_SH}
	source src.ui.sh

	pgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
