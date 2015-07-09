# UI part of all dtfiles tool
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

function print_help() {
			cat <<EOF
Usage: $DTFILES_SH_INFO [options] -- dts_filename

$DTFILES_SH_INFO searches for filenames recursevely in a device-tree file
until all included dtsi files are parsed.

Example:
  $DTFILES_SH_INFO -n msm8994-v2.1.dts

  -h        Print this help.

EOF
}
	while getopts h OPTION; do
		case $OPTION in
		h)
			print_help $0
			exit 0
			;;
		?)
			echo "Syntax error:" 1>&2
			print_help $0 1>&2
			exit 2
			;;
		esac
	done
	shift $(($OPTIND - 1))

	if [ $# -ne 1 ]; then
		echo "Syntax error:" \
			"$DTFILES_SH_INFO number of arguments should be exactly one:" \
			"dts_filename" 1>&2
		echo "For help, type: $DTFILES_SH_INFO -h" 1>&2
		exit 2
	fi

