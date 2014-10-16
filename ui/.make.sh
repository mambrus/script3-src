# UI part of colorized make
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

DEF_CONFIG="${HOME}/bin/.src..gcc.grc"

function print_help() {
			cat <<EOF
Colorize make output if suitable. Wraps make and can be used instead of it
as a alias.

Usage: $MAKE_SH_INFO [options] -- [make_options] [make_target]

To be used exacly as make

Example:
$MAKE_SH_INFO -j4 all


  -n        Force no-colorized output no matter of COLORIZED_MAKE
  -c        Force colorized output no matter of COLORIZED_MAKE
  -h        Print this help and env variables. Note: due to mentioned
            variables, it mattes where -h appears on the command line.

EOF
}

	while getopts hnc OPTION; do
		case $OPTION in
		h)
			print_help $0
			exit 0
			;;
		n)
			COLORIZED_MAKE="NO"
			;;
		c)
			COLORIZED_MAKE="YES"
			;;
		?)
			break
			;;

		esac
	done
	shift $(($OPTIND - 1))

	if [ "X${COLORIZED_MAKE}" == "XYES" ]; then
		COLOR_PARAM="always"
	elif [ "X${COLORIZED_MAKE}" == "XNO" ]; then
		COLOR_PARAM="never"
	else
		COLOR_PARAM="auto"
	fi


	CONFIGF=${CONFIGF-${DEF_CONFIG}}


