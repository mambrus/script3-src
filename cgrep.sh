#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

if [ -z $CGREP_SH ]; then

CGREP_SH="cgrep.sh"

# Atempts to work as the very useful Android cgrep utility

function cgrep() {
	local PATTERN='\(.*\.c$\|.*\.h$\|.*\.s$\|.*\.ld$\)'
	find . -iregex "${PATTERN}" -exec egrep "${1}" -nH "${2}" '{}' ';'
}


source s3.ebasename.sh
if [ "$CGREP_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.


function print_help() {
			cat <<EOF
Usage: $CGREP_SH [options] -- regexp_pattern

Example:
  $CGREP_SH -n my_specific_cfunction

  -n		Force no-colorized output no matter of COLORIZED_GREP
  -c		Force colorized output no matter of COLORIZED_GREP
  -h		Print this help
EOF
}
	while getopts h:n:c OPTION; do
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

	cgrep "$@" "${COLOR_PARAM}"

	exit $?
fi

fi
