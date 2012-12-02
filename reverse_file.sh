#!/bin/bash

REVERSE_FILE="reverse_file.sh"

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

source s3.ebasename.sh
if [ "$REVERSE_FILE" == $( ebasename $0 ) ]; then
  #Not sourced, do something with this.

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

  reverse_file "$TEMPFILE"
  rm -f "$TEMPFILE"

fi
unset REVERSE_FILE

