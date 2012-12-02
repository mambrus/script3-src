#!/bin/bash

TRACES2SRCREF_SH="traces2srcref.sh"


if [ "$TRACES2SRCREF_SH" == $( basename $0 ) ]; then
  #Not sourced, do something with this.
  source vim_traceopen.sh
  source user_response.sh

  if [ ! -f jpacks ]; then
    ask_user_continue \
      "No \"jpacks\" file found. Want me to try create one? (Y/n)"\
      "Creating file..."\
      "Please create one manually the retry sript. see: http://mibwiki.sonyericsson.net/index.php/MiB_Michael_Ambrus#Generate_a_packages_file_to_search_in"
      RC=$?
      if [ $RC -eq 0 ]; then
        find . -name "*.java" -exec egrep -nH '^package'  '{}' ';' | \
          awk -F":" '{print  $3 $1}' | \
          grep -v '\./out/' | grep -v '.dalvik/dx/tests/' | sort > jpacks
      else
        exit -1
      fi
  fi

  if [ ! -f $1 ]; then
    echo "Error: No traces file provided or found as arg1"
    echo "  Please provide one"
    exit -2
  fi

  CHECKS=$(grep "DALVIK THREADS" $1)
  if [ "x${CHECKS}" == "x" ]; then
	echo "Error: Not a valid Dalvik traces file"
	echo "  Please provide one"
	exit -3
  fi

  if [ "x$2" == "x" ]; then
	echo "Error: No Thread ID given"
	echo "  Please provide one"
	exit -4
  fi

  SYSTIDS=$(grep "sysTid" $1 | sed -e 's/[[:space:]]nice.*$//' | awk -F"=" '{print $2}' | sort -n)

  TID_FOUND="NO"
  for STID in $SYSTIDS; do
	if [ "x${STID}" == "x$2" ]; then
	  TID_FOUND="YES"
	fi
  done

  if [ "x${TID_FOUND}" == "xNO" ]; then
	echo "Error: No Valid Thread-ID given"
	echo "  Please provide one. The following are in the traces file:"
	for STID in $SYSTIDS; do
	  echo -n "$STID "
	done
	echo
	exit -5
  fi

  ATS=$(sed -ne "/sysTid=$2/,/sysTid/ p" < $1 | egrep '^[[:space:]]+at' | sed -e 's/[[:space:]]/£/g' )
  for A in $ATS; do
	#ALINE=$(echo "$A" | sed -e 's/£/ /g; s/\$/\\$/')
	ALINE=$(echo "$A" | sed -e 's/£/ /g; s/\$[[:alnum:]]*\././')
	#ALINE='  at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:799)'

	#echo "$ALINE" | sed -e 's/\$[[:alnum:]]*\././'
	#echo "$ALINE ----------------------->"
	source_pos "$ALINE"
	#source_pos "$A"
  done
fi

unset TRACES2SRCREF_SH
