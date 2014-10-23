#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2014-10-16

if [ -z $MAKE_SH ]; then

MAKE_SH="make.sh"

function make_colorized() {
	local MAKE_ARGS=$1
	local HAD_PIPEFAIL=$(set | grep pipefail | grep SHELLOPTS)

	set -o pipefail
	( make  ${MAKE_ARGS} 2>&1 ) | grcat ${CONFIGF}
	local RC=$?
	if [ "no${HAD_PIPEFAIL}"  == "no"  ]; then
		set +o pipefail
	fi
	return $RC
}

function _make() {
	local COLOR_PARAM=$1
	local MAKE_ARGS=$2

	if [ "X${COLOR_PARAM}" == "Xauto" ]; then
		if [ "X${VIM}" == "X" ]; then
		   GRCAT=$(which grcat)
		fi
		if [ "X${GRCAT}" != "X" ]; then
			make_colorized ${MAKE_ARGS}
			return $?
		else
			make ${MAKE_ARGS}
			return $?
		fi
	elif [ "X${COLOR_PARAM}" == "Xalways" ]; then
		make_colorized ${MAKE_ARGS}
		return $?
	else
		make ${MAKE_ARGS}
		return $?
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
