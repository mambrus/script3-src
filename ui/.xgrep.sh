# UI part of all xgrep tool
# This is not even a script, stupid and can't exist alone. It is purely
# meant for being included.

# XGREP_FIND_RE default sitting. Environment has precedence. This ability is
# heavily deployed by all sub-scripts to xgrep.sh as the main way of
# communicating patterns.
if [ "X${XGREP_FIND_RE}" == "X" ]; then
	XGREP_FIND_RE='\(.*\)'
fi

if [ "X${XGREP_SH_INFO}" == "Xxgrep.sh" ]; then
	REJBIN_TRY_HARDER=${REJBIN_TRY_HARDER-"yes"}
else
	REJBIN_TRY_HARDER=${REJBIN_TRY_HARDER-"no"}
fi

# XGREP_FIND_IGNORE default sitting. Environment has precedence. Note that
# the format differ wrt XGREP_FIND_RE. Thats because excluding files cant's be
# done with -path. The file-patterns are known-to-be binaries. This quite
# elaborate variable makes most sense when using xgrep directly.
if [ "X${XGREP_FIND_IGNORE}" == "X" ]; then
	XGREP_FIND_IGNORE='
		-path ./out* -prune -o
		-path ./.repo/ -prune -o
		-path "*/.git/" -prune -o
		-regex .*\.o$ -prune -o
		-regex .*\.pyc$ -prune -o
		-regex .*/vmlinux$ -prune -o
		-regex .*/c-tags$ -prune -o
		-regex .*/tags$ -prune -o
		-regex .*\.bin$ -prune -o
		-regex .*\.img$ -prune -o
		-regex .*\.gz$ -prune -o
		-regex .*pack-.*\.pack$ -prune -o
		-regex .*\.gz$ -prune -o
		-regex .*\.ko$ -prune -o '
fi

function print_help() {
			cat <<EOF
Usage: $XGREP_SH_INFO [options] -- regexp_pattern

Example:
  $XGREP_SH_INFO -n my_specific_sring

$XGREP_SH_INFO -f '-L' -ig'-A1 -B1' 'leds-Pwm.c'
   find follows links, grep prints lines before and after.

src.xgrep.sh -E'*/drivers/video/*' -E'*/arch/arm/*' -x'.*\.cmd$' -i 'pwm\.h'
   Find vermatim string in linux sources, excluding 2 directories and all
   files ending with *.cmd.

  -n        Force no-colorized output regardless of COLORIZED_GREP
  -c        Force colorized output regardless of COLORIZED_GREP
  -i        Ignore capital & non-captal letters while searching in files.
            This is a conveniance option for backend grep with the same
            meaning since it's so common. I.e. you don't need to use the -G
            option for this.
  -b        Try harder to reject binaries before searching in them. Default
            depends on which src.*grep.sh is executing.
            Current default: [$REJBIN_TRY_HARDER]
  -I        Ignore noT difference between capital & non-captal letters
            in file patterns. Defaul is to do but if you know
            pattern is OK, this will speed up search about 40%.
  -f        Extra options to find. String sent verbatim as-is to find.
  -F        Append extra options to find. String is appended to any
            pre-existing XGREP_FIND_OPTS before sent verbatim to find. The
            option can hence as a side-effect be passed several times.
  -g        Extra options to grep. String sent verbatim as-is to find.
  -G        Append extra options to grep. String is appended to any
            pre-existing XGREP_GREP_OPTS before sent verbatim to grep. The
            option can hence as a side-effect be passed several times.
  -E        Append exclude paths to XGREP_FIND_IGNORE. Use this to exclude file
            patterns.
  -x        Append exclude regex to XGREP_FIND_IGNORE. Use this to exclude file
            patterns.
  -h        Print this help and env variables. Note: due to mentioned
            variables, it mattes where -h appears on the command line.

Caution:
    With -[fFeE] is possible to enter all sorts of side-effects related to
    find (-l) or grep (-g). Distributions version of underlaying commands
    determine what happens. For example: With -f/F '-L' it's possibible to
    enter find-loops. Your distributions version of find what to do with
    loops (normally repeating the loop but limited to twice).

Current env variables:
   XGREP_FIND_OPTS [$XGREP_FIND_EXTRAS]
   XGREP_GREP_OPTS [$XGREP_GREP_EXTRAS]
   XGREP_FIND_RE     [$XGREP_FIND_RE]
   XGREP_FIND_IGNORE      [$XGREP_FIND_IGNORE]

Note:
   Environment can be pre-set. That includes all vars mentioned above.
   Calling environment has precedence.

EOF
}
	while getopts hncIif:F:g:G:E:x:b: OPTION; do
		case $OPTION in
		h)
			print_help $0
			exit 0
			;;
		n)
			COLORIZED_GREP="no"
			;;
		c)
			COLORIZED_GREP="yes"
			;;
		I)
			IGNORE_CAP_FILEPATT="no"
			;;
		f)
			XGREP_FIND_OPTS="${OPTARG}"
			;;
		F)
			XGREP_FIND_OPTS="${XGREP_FIND_EXTRAS} ${OPTARG}"
			;;
		g)
			XGREP_GREP_OPTS="${OPTARG}"
			;;
		G)
			XGREP_GREP_OPTS="${XGREP_GREP_EXTRAS} ${OPTARG}"
			;;
		b)
			REJBIN_TRY_HARDER="${OPTARG}"
			;;
		i)
			XGREP_GREP_OPTS="${XGREP_GREP_EXTRAS} -i"
			;;
		E)
			XGREP_FIND_IGNORE="${XGREP_FIND_IGNORE}"'
		'"-path ${OPTARG} -prune -o "
			;;
		x)
			XGREP_FIND_IGNORE="${XGREP_FIND_IGNORE}"'
		'"-regex ${OPTARG} -prune -o "
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

	if [ "X${COLORIZED_GREP}" == "Xyes" ]; then
		COLOR_PARAM="--color=always"
	elif [ "X${COLORIZED_GREP}" == "Xno" ]; then
		COLOR_PARAM="--color=never"
	else
		COLOR_PARAM="--color=auto"
	fi

	IGNORE_CAP_FILEPATT=${IGNORE_CAP_FILEPATT-"yes"}

