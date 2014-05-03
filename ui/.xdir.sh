# UI part of all xgrep tool
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

# XGREP_PATTERN default sitting. Environment has precedence. This ability is
# heavily deployed by all sub-scripts to xgrep.sh as the main way of
# communicating patterns.
if [ "X${XGREP_PATTERN}" == "X" ]; then
	XGREP_PATTERN='\(.*\)'
fi

# XGREP_IGNORE_PATH default sitting. Environment has precedence.
if [ "X${XGREP_IGNORE_PATH}" == "X" ]; then
	XGREP_IGNORE_PATH='
		-path "*/tags*" -prune -o \
		-path "*/c-tags*" -prune -o \
		-path "*/*.ko" -prune -o \
		-path "*/*.o" -prune -o \
		-path "./out*" -prune -o \
		-path "./.repo/" -prune -o \
		-path "*/.git/*" -prune -o '
fi

function print_help() {
			cat <<EOF
Usage: $XGREP_SH_INFO [options] -- regexp_pattern

Example:
  $XGREP_SH_INFO -n my_specific_sring

$XGREP_SH_INFO -f '-L' -ig'-A1 -B1' 'leds-Pwm.c'
   find follows links, grep prints lines before and after.

  -n        Force no-colorized output no matter of COLORIZED_GREP
  -c        Force colorized output no matter of COLORIZED_GREP
  -i        Ignore NOT difference between capital/non-captal letters
			in search paths filenames. Defaul is to do but if you know
			pattern is OK, this will speed up search about 40%.
  -f        Extra options to find. String sent verbatim as-is to find.
  -F        Append extra options to find. String is appended to any
            pre-existing XGREP_FIND_EXTRAS before sent verbatim to find. The
            option can hence as a side-effect be passed several times.
  -g        Extra options to grep. String sent verbatim as-is to find.
  -G        Append extra options to grep. String is appended to any
            pre-existing XGREP_GREP_EXTRAS before sent verbatim to grep. The
            option can hence as a side-effect be passed several times.
  -E        Append exclude paths to XGREP_IGNORE_PATH.
  -h        Print this help and env variables. Note: due to mentioned
            variables, it mattes where -h appears on the command line.

Caution:
    With -[fFeE] is possible to enter all sorts of sideeffects related to
    find (-l) or grep (-g). Distributions version of underlaying commands
    determine what happens. For example: With -f/F '-L' it's possibible to
    enter find-loops. Your distributions version of find what to do with
    loops (normally repeating the loop but limited to twice).

Current env variables:
   XGREP_FIND_EXTRAS [$XGREP_FIND_EXTRAS]
   XGREP_GREP_EXTRAS [$XGREP_GREP_EXTRAS]
   XGREP_PATTERN     [$XGREP_PATTERN]
   XGREP_IGNORE_PATH [$XGREP_IGNORE_PATH]

EOF
}
	while getopts hncif:F:g:G:E: OPTION; do
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
			IGNORE_CAP="NO"
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
		E)
			XGREP_IGNORE_PATH="${XGREP_IGNORE_PATH}\\"'
		'"-path \"${OPTARG}\" -prune -o "
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

