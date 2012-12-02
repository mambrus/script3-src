#!/bin/bash
#Example of usage:
#First start an empty vim like a server, lets say the servername
#vim --servername kalle
#Then in another console, execute like this
#VIMS=$( traces2srcref.sh traces.txt 1483 | vim_src2stack.sh ); for V in "$VIMS"; do vim  --servername kalle --remote-send "$V"; done

VIM_SRC2STACK_SH="vim_src2stack.sh"

function reverse_file()
{
  if [ -z $1 ]; then
	echo "  Error: Need one parameter, the file to reverse"
	return -1
  fi

  local  NLINES=$(wc -l "$1" |  cut -f1 -d" ")

  for (( i=0 ; $i < $NLINES; i++ )); do
	(( n = NLINES - i ))
	tail -n$i $1 | head -n1
  done
}

function convert2_vim_editcmd()
{
  cat -- | awk -F":" '{print ":vie +"$2-1" "$1"<enter>"}'
}

if [ "$VIM_SRC2STACK_SH" == $( basename $0 ) ]; then
  #Not sourced, do something with this.

#  cat -- | convert2_vim_editcmd
#  exit 0

  PID=$$
  #Use Bash temp-dir if set.
  if [ -z "${TMPDIR}" ]; then
	TEMPFILE="temp_$( basename $0 ).$PID"
  else
	TEMPFILE="${TMPDIR}/temp_$( basename $0 ).$PID"
  fi

  if [ -z "$(tty)" ]; then
	cat -- >> "$TEMPFILE"
  else
	cat $1 >> "$TEMPFILE"
  fi

  reverse_file "$TEMPFILE" | convert2_vim_editcmd
  rm -f "$TEMPFILE"

fi

unset VIM_SRC2STACK_SH

