# UI part of all cmake_clean tool
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

CMAKE_CLEAN_FIND_DIR=${CMAKE_CLEAN_FIND_DIR-'./'}

function print_help() {
			cat <<EOF
Usage: $CMAKE_CLEAN_SH_INFO [options]

Examples:
  $CMAKE_CLEAN_SH_INFO -d some/relative/dir

  $CMAKE_CLEAN_SH_INFO -d /some/absolute/dir

  -d <dir>  Find and remove cmake arifacts from this directory
  -h        Print this help and env variables. Note: due to mentioned
            variables, it mattes where -h appears on the command line.

Caution:
    (TBD)

Environment variables:
   CMAKE_CLEAN_FIND_DIR [$CMAKE_CLEAN_FIND_DIR]

Note:
   Environment can be pre-set. That includes all vars mentioned above.
   Calling environment has precedence.

EOF
}
	while getopts hd: OPTION; do
		case $OPTION in
		h)
			print_help $0
			exit 0
			;;
		d)
			CMAKE_CLEAN_FIND_DIR="${OPTARG}"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	if [ $# -ne 0 ]; then
		echo "Syntax error:" \
			"$CMAKE_CLEAN_SH_INFO doesn't take any arguments." 1>&2
		echo "For help, type: $CMAKE_CLEAN_SH_INFO -h" 1>&2
		exit 2
	fi


