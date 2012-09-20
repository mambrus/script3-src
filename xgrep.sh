#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-20
# This is the backend for all src.*grep.sh tools. All it needs is a pattern
# in the envvar XGREP_PATTERN

if [ -z $XGREP_SH ]; then

XGREP_SH="xgrep.sh"

# Atempts to work as the very useful Android xgrep utility

function xgrep() {
	local PATTERN='\(.*\.c$\|.*\.h$\|.*\.s$\|.*\.ld$\)'
	find . -iregex "${PATTERN}" -exec egrep "${1}" -nH "${2}" '{}' ';'
}


source s3.ebasename.sh
if [ "$XGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.


function print_help() {
			cat <<EOF
Usage: $XGREP_SH [options] -- regexp_pattern

Example:
  $XGREP_SH -n my_specific_cfunction

  -n		Force no-colorized output no matter of COLORIZED_GREP
  -c		Force colorized output no matter of COLORIZED_GREP
  -h		Print this help
EOF
}
	while getopts n:c:h OPTION; do
		case $OPTION in
		h)
			print_help $0
			exit 0
			;;
		n)
			COLORIZED_GREP="NO"
			;;
		c)
			COLORIZED_GREP="YES"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))
	
	if [ "X${COLORIZED_GREP}" == "XYES" ]; then
		COLOR_PARAM="--color=always"
	elif [ "X${COLORIZED_GREP}" == "XNO" ]; then
		COLOR_PARAM="--color=never"
	else
		COLOR_PARAM="--color=auto"
	fi

	xgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
