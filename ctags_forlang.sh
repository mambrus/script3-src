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
	mkdir "$TMPDIR"
  fi

  echo "Making links to *.ctags files"

  CTAGS_FILES="$(( ls $HOME/bin/*.ctags 2>/dev/null )  | sed -e 's/^.*\///')"
  if [ "X" != "X${CTAGS_FILES}" ]; then
	echo -n "Linking ["
	for F in $CTAGS_FILES; do
	  echo -n " $F"
	  ln -sf "$HOME/bin/$F"
	done
	echo " ]"

	ask_user_continue "Would you like me to run ctags for a particular language for you? (Y/n)" "Understood" "Ignoring..."
	local RC=$?
	
	local LANGUAGE=$1
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
			ctags --options=src.java-only.ctags  --exclude=@src.exclude_patterns.ctags -o j-tags -R *
			ln -sf j-tags tags
			RC=1
			;;
		java)
			echo "Running ctags for language [Java]. Please wait..."
			ctags --options=src.java-only.ctags  --exclude=@src.exclude_patterns.ctags -o j-tags -R *
			ln -sf j-tags tags
			RC=1
			;;
		C)
			echo "Running ctags for language [C]. Please wait..."
			ctags --options=src.c-only.ctags  --exclude=@src.exclude_patterns.ctags -o c-tags -R *
			ln -sf c-tags tags
			RC=1
			;;

		c)
			echo "Running ctags for language [C]. Please wait..."
			ctags --options=src.c-only.ctags  --exclude=@src.exclude_patterns.ctags -o c-tags -R *
			ln -sf c-tags tags
			RC=1
			;;
		*)
			echo
			echo "I can't handle language [$LANGUAGE]. Try again..."
			LANGUAGE=""
			echo
			;;
		esac
    done
    return 0
  else
	echo "No [~/bin/*.ctags] files found. Can't continue... Please check your setup"
  fi
}

source s3.ebasename.sh

if [ "$CTAGS_FORLANG_SH" == $( ebasename $0 ) ]; then
  #Not sourced, do something with this.
  source s3.user_response.sh

  ctags_forlang $@
fi
