#!/bin/bash
# Set up ctags
#
# Author: Michael Ambrus MiB, Aug 26, 2010
#
#Note: This should be run in your source root to be meaningful.

CTAGS_SETUP_MYPROJECT_SH="ctags_setup_myproject.sh"
if [ "$CTAGS_SETUP_MYPROJECT_SH" == $( basename $0 ) ]; then
  #Not sourced, do something with this.
  set -e
  set -u
  source user_response.sh


  echo "Making links to *.ctags files"

  CTAGS_FILES="$(( ls $HOME/bin/*.ctags 2>/dev/null )  | sed -e 's/^.*\///')"
  if [ "X" != "X$CTAGS_FILES" ]; then
	echo -n "Linking ["
	for F in $CTAGS_FILES; do
	  echo -n " $F"
	  ln -sf $HOME/bin/$F
	done
	echo "]"

#	set +e
#	ask_user_continue "Would you like me to link any ofthose for you? (Y/n)" "Linking to symbols..." "Ignoring linking..."
#	RC=$?
#	set -e
#export TMPDIR="$HOME/tmp/tmp/"
  else
	echo "Nothing to link..."
  fi


fi
