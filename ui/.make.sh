# UI part of colorized make
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

DEF_CONFIG="${HOME}/bin/.src..gcc.grc"

function print_help() {
			cat <<EOF
Wrapper for colorizeing make output if suitable. Wraps make and can be used
instead of it as a alias.

Usage: $MAKE_SH_INFO [options] -- [make_options] [make_target]

To be used exacly as make

Example:
$MAKE_SH_INFO -j4 all


  -n        Force no-colorized output no matter of COLORIZED_MAKE
  -c        Force colorized output no matter of COLORIZED_MAKE
  -h        Print this help and env variables. Note: due to mentioned
            variables, it mattes where -h appears on the command line.

To pass any flag used by the wrapper to the wrapped shell, use '--'.
For example if [$1] is an alias and you want to pass '-h' to make:

make -- -h

EOF
}
	# Reroute stderr as getopt rapports on it and it if disabled by getopt -q,
	# nothing works
	exec 3>&2 2>/dev/null

	set -- $(getopt hnc "$@")
	while [ $# -gt 0 ]
	do
		case "$1" in
		(-h) print_help $0; exit 0;;
		(-n) COLORIZED_MAKE="NO"; shift;;
		(-c) COLORIZED_MAKE="YES"; shift;;
		(--) shift; break;;
		#These make no difference, kept for reference.
		#(-*) echo "$0: error - unrecognized option $1" 1>&2; exit 1;;
		#(*)  echo "Hepp!!!"; break;;
		esac
		shift
	done
	exec 2>&3 3>&-

#	while getopts hnc OPTION; do
#		case $OPTION in
#		h)
#			print_help $0
#			exit 0
#			;;
#		n)
#			COLORIZED_MAKE="NO"
#			;;
#		c)
#			COLORIZED_MAKE="YES"
#			;;
#		?)
#			break
#			;;
#
#		esac
#	done
#	shift $(($OPTIND - 1))

	if [ "X${COLORIZED_MAKE}" == "XYES" ]; then
		COLOR_PARAM="always"
	elif [ "X${COLORIZED_MAKE}" == "XNO" ]; then
		COLOR_PARAM="never"
	else
		COLOR_PARAM="auto"
	fi


	CONFIGF=${CONFIGF-${DEF_CONFIG}}


