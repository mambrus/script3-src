#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2014-10-16

if [ -z $MAKE_SH ]; then

MAKE_SH="make.sh"

function _make() {
	local COLOR_PARAM=$1
	local MAKE_ARGS=$2

	if [ "X${COLOR_PARAM}" == "Xauto" ]; then
		if [ "X${VIM}" == "X" ]; then
		   GRCAT=$(which grcat)
		fi
		if [ "X${GRCAT}" != "X" ]; then
			( make  ${MAKE_ARGS} 2>&1 ) | grcat ${CONFIGF}
		else
			make ${MAKE_ARGS}
		fi
	elif [ "X${COLOR_PARAM}" == "Xalways" ]; then
		( make  ${MAKE_ARGS} 2>&1 ) | grcat ${CONFIGF}
	else
		make ${MAKE_ARGS}
	fi
}

source s3.ebasename.sh
if [ "$MAKE_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	MAKE_SH_INFO=${MAKE_SH}
	source .src.ui..make.sh

	_make "${COLOR_PARAM}" "$@"

	exit $?
fi

fi
