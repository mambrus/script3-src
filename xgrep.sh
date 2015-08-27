#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-20
# This is the back-end for all src.*grep.sh tools. All it needs is a pattern
# in the envvar XGREP_FIND_RE. If run as front-end, it will search for
# everything (which is basically equal to the normal egrep)

if [ -z $XGREP_SH ]; then

XGREP_SH="xgrep.sh"

# File content filter only for text, i.e. possible source.
function fc_filter() {
	if [ "X${REJBIN_TRY_HARDER}" == "Xyes" ]; then
		#if [ $() ]
#find . | xargs -I '{}' file '{}' | grep -Ev 'text$'

		cat --
	else
		cat --
	fi
}

function xgrep() {
	local CONTENT_PATTERN="${1}"
	local COLOR_PARAM="${2}"

	if [ "X${XGREP_FIND_RE}" == "X" ]; then
		echo "Warning: XGREP_FIND_RE is unset. Assigning default" 2>&1
		XGREP_FIND_RE='\(.*\)'
	fi

	if [ "X${IGNORE_CAP_FILEPATT}" == "XNO" ]; then
		local REGEXP_BIN="regex"
	else
		#Note: This execution path is the default
		local REGEXP_BIN="iregex"
	fi

	find ${XGREP_FIND_OPTS} . \
		${XGREP_FIND_IGNORE} \
		-${REGEXP_BIN} "${XGREP_FIND_RE}" \
		-type f | \
			fc_filter | \
			xargs -I '{}' egrep \
				${XGREP_GREP_OPTS} \
				"${CONTENT_PATTERN}" \
				-nH \
				"${COLOR_PARAM}" \
				'{}'
}


source s3.ebasename.sh
if [ "$XGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	XGREP_SH_INFO=${XGREP_SH}
	source .src.ui..xgrep.sh

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
