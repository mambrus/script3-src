#!/bin/bash
# Set up ctags
#
# Author: Michael Ambrus MiB, Aug 26, 2010
#
#Note: This should be run in your source root to be meaningful.


CTAGS_FORLANG_SH="ctags_forlang.sh"

function ctags_forlang() {
	set -e
	set +u

	export TMPDIR="${HOME}/tmp/.ctags_tmp"
	if [ ! -d "$TMPDIR" ]; then
		mkdir -p "$TMPDIR"
	fi

	CTAGS_FILES="$(( ls $HOME/bin/*.ctags 2>/dev/null )  | sed -e 's/^.*\///')"
	if [ "X" == "X${CTAGS_FILES}" ]; then
		echo -n "No [~/bin/*.ctags] files found. Can't continue..." 1>&2
		echo "Please check your setup" 1>&2
		exit 1
	fi

	local LANGUAGE=$1
	local RC=0

	while [ $RC -eq 0 ]
	do
		if [ "X" == "X$LANGUAGE" ]; then
		  echo -n "Please enter language: "
		  read LANGUAGE
		  echo
		fi

		case "$LANGUAGE" in
		"")
			echo "There is no default. Try again..."
			;;
		Java)
			echo "Running ctags for language [Java]. Please wait..."
			ctags --options=${HOME}/bin/src.java-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o j-tags -R *
			ln -sf j-tags tags
			local RC=1
			;;
		java)
			echo "Running ctags for language [Java]. Please wait..."
			ctags --options=${HOME}/bin/src.java-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o j-tags -R *
			ln -sf j-tags tags
			local RC=1
			;;
		lua)
			echo "Running ctags for language [Java]. Please wait..."
			ctags --options=${HOME}/bin/src.lua-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o j-tags -R *
			ln -sf j-tags tags
			local RC=1
			;;
		make)
			echo "Running ctags for language [Make]. Please wait..."
			ctags --options=${HOME}/bin/src.make-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o m-tags -R *
			ln -sf m-tags tags
			local RC=1
			;;
		Make)
			echo "Running ctags for language [Make]. Please wait..."
			ctags --options=${HOME}/bin/src.make-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o m-tags -R *
			ln -sf m-tags tags
			local RC=1
			;;
		C)
			echo "Running ctags for language [C]. Please wait..."
			ctags --options=${HOME}/bin/src.c-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o c-tags -R * \
				--links="yes"
			ln -sf c-tags tags
			local RC=1
			;;
		c)
			echo "Running ctags for language [C]. Please wait..."
			ctags --options=${HOME}/bin/src.c-only.ctags  \
				\
				--exclude="mnt/*"\
				--exclude=@${HOME}/bin/src.exclude_patterns.ctags -o c-tags -R * \
				--links="yes"
			ln -sf c-tags tags
			local RC=1
			;;
		*)
			echo
			echo "I can't handle language [$LANGUAGE]. Try again..."
			local LANGUAGE=""
			echo
			;;
		esac
	done
	return 0
}

source s3.ebasename.sh

if [ "$CTAGS_FORLANG_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	ctags_forlang $@
	which cscope >/dev/null && cscope -R -b
fi
