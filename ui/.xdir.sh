# UI part of all xgrep tool
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_help() {
			cat <<EOF
Usage: $XGREP_SH_INFO [options] -- regexp_pattern

Example:
  $XGREP_SH_INFO -n my_specific_cfunction

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
