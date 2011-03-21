#!/bin/bash

# Searches for symbol in libfiles
# Usage: symbol_find.sh '<regexp>'
# Author: Michael Ambrus <ambrmi09@gmail.com>
# 2011-01-23

if [ -z ${MASHINE} ];	then MASHINE=arm; fi
if [ -z ${SYSTEM} ];	then SYSTEM=hixs; fi
if [ -z ${ABI} ];		then ABI=elf; fi

OBJDUMP=${MASHINE}-${SYSTEM}-${ABI}-objdump

if [ ! $# -eq 1 ]; then
	echo "Syntax error: symbol_find.sh '<regexp>'" 1>&2 
	echo " You need exactly one argument, a regexp for the symbol" 1>&2
	exit 1
fi

FILES=$(find . -regex ".*${MASHINE}.*\.a\$") 
for F in $FILES; do 
	HITS=$( ${OBJDUMP} -tT $F | \
		egrep "$1" | \
		grep -v UND 
	); 
	if [ ! -z "$HITS" ]; then 
		echo -n "$HITS : "
		echo $F; 
	fi
done 2>/dev/null

