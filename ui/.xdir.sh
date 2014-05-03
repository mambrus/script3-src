# UI part of all xgrep tool
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_help() {
			cat <<EOF
Usage: $XGREP_SH_INFO [options] -- regexp_pattern

Example:
  $XGREP_SH_INFO -n my_specific_sring

$XGREP_SH_INFO -f '-L' -ig'-A1 -B1' 'leds-Pwm.c'

  -n        Force no-colorized output no matter of COLORIZED_GREP
  -c        Force colorized output no matter of COLORIZED_GREP
  -i        Ignore difference between capital/non-captal letters
  -f        Extra options to find. String sent verbatim as-is to find.
  -F        Append xtra options to find. String is appended to any
            pre-existing XGREP_FIND_EXTRAS before sent verbatim to find. The
            option can hence as a side-effect be passed several times.
  -g        Extra options to grep. String sent verbatim as-is to find.
  -G        Append xtra options to grep. String is appended to any
            pre-existing XGREP_GREP_EXTRAS before sent verbatim to grep. The
            option can hence as a side-effect be passed several times.
  -h        Print this help

Caution:
    With -[fFeE] is possible to enter all sorts of sideeffects related to
    find (-l) or grep (-g). Distributions version of underlaying commands
    determine what happens. For example: With -f/F '-L' it's possibible to
    enter find-loops. Your distributions version of find what to do with
    loops (normally repeating the loop but limited to twice).

EOF
}
	while getopts hncif:F:g:G: OPTION; do
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
		i)
			IGNORE_CAP="YES"
			;;
		f)
			XGREP_FIND_EXTRAS="${OPTARG}"
			;;
		F)
			XGREP_FIND_EXTRAS="${XGREP_FIND_EXTRAS} ${OPTARG}"
			;;
		g)
			XGREP_GREP_EXTRAS="${OPTARG}"
			;;
		G)
			XGREP_GREP_EXTRAS="${XGREP_GREP_EXTRAS} ${OPTARG}"
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
			"$XGREP_SH_INFO number of arguments should be exactly one:" \
			"regexp_pattern" 1>&2
		echo "For help, type: $XGREP_SH_INFO -h" 1>&2
		exit 2
	fi

	if [ "X${COLORIZED_GREP}" == "XYES" ]; then
		COLOR_PARAM="--color=always"
	elif [ "X${COLORIZED_GREP}" == "XNO" ]; then
		COLOR_PARAM="--color=never"
	else
		COLOR_PARAM="--color=auto"
	fi

	IGNORE_CAP={$IGNORE_CAP-"NO"}

