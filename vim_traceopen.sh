#!/bin/bash

VIM_TRACEOPEN_SH="vim_traceopen.sh"

# This function translates an traces entry includeing line-no like for example:
#   at com.android.internal.os.ZygoteInit$MethodAndArgsCaller.run(ZygoteInit.java:799)
# ...into:
#  path/to/sorce/file/Class.java:nnn
#
# Note that this line-lype is one of two variants
function extract_spos1()
{
  #echo "$1"

  local TR_LINE="$1"
  local CLASSFILE_NO=$(echo "$TR_LINE" | sed -e 's/.*[[:space:]]\+//; s/.*(//; s/).*$//')
  #echo "CLASSFILE_NO=$CLASSFILE_NO"

  local SEARCH_LINE=$(echo -n "package "; echo -n "$TR_LINE" | sed -e 's/.*[[:space:]]\+//; s/\.[[:alnum:]]\+\.[[:alnum:]]\+(.*$//'; echo ";")
  #echo "SEARCH_LINE=$SEARCH_LINE"

  echo -n $(grep "$SEARCH_LINE" jpacks |
    grep $(echo $CLASSFILE_NO | sed -e 's/:.*$//') | awk -F";" '{print $2}');
    echo -n ":"; echo "$CLASSFILE_NO" | sed -e 's/.*://'
}

# This function translates an traces entry includeing NO line-no like for example:
#   at java.lang.Object.wait(Native Method)
#   at com.android.server.SystemServer.init1(Native Method)
# ...into:
#  path/to/sorce/file/Class.java:nnn
#
# Note(s)
# 1) This version totally ignores the contents of paranthesis (or even that there are any)
# 2) It will position vim on either the method, the class or if either is found. Top of file
# 3) This line-type is the other of two variants
function extract_spos2()
{
  local TR_LINE=$(echo "$1" | sed -e 's/[[:space:]]\+$//' )
  #The class has to be extracted from next but last of the FCN
  local CLASS=$(echo "$TR_LINE" | sed -e 's/(.*$//; s/.[[:alnum:]]\+$//; s/.*\.//')
  #echo "CLASS=$CLASS"

  #The method is extracted from the last part of th FCN
  local METHOD=$(echo "$TR_LINE" | sed -e 's/(.*$//; s/.*\.//')
  #echo "METHOD=$METHOD"

  #The package is all of the first part of the FCN, except the last two parts
  local PACKAGE=$(echo "$TR_LINE" | sed -e 's/(.*$//; s/.[[:alnum:]]\+$//;  s/.[[:alnum:]]\+$//; s/.*[[:space:]]//')
  #echo "PACKAGE=$PACKAGE"
  #cho "TR_LINE=$TR_LINE"

  #Add som extras, so the search gets what we need from the jpacks file
  local SEARCH_LINE=$(echo -n "package "; echo -n "$PACKAGE"; echo ";")
  #echo "SEARCH_LINE=$SEARCH_LINE"

  #Rip obsolete info away from the hit, i.e. refine it to a filename. Note, may result in multilpe hits if people name stupidly. Take the first one.
  local SRC_FILE=$(grep "$SEARCH_LINE" jpacks | grep $(echo "${CLASS}.java") | head -n1 | awk -F";" '{print $2}')
  #echo "SRC_FILE=$SRC_FILE"

  # For the line-no, we need to guess since signature is not available to us.
  # (normally this is evident from the preceedig call in the stack however).
  # So let's pick the first one and leave the rest for the user to figure out.

  SRCLINE=$(grep -nH "$METHOD" "$SRC_FILE" | egrep '(private|public)'  | head -n1 | awk -F":" '{print $1":"$2}')

  if [ "x$SRCLINE" != "x" ]; then
    echo "$SRCLINE"
  else
	echo "${SRC_FILE}:0"
  fi
}

function source_pos() {
  local BRACKET_CONTENT=$(echo "$1" | sed -e 's/.*(//; s/).*//')
  local LINE_NO=$(echo "$BRACKET_CONTENT" | awk -F":" '{print $2}')
  if [ "x$LINE_NO" == "x" ]; then
    extract_spos2 "$1"
  else
    extract_spos1 "$1"
  fi
}

#This function is used to translate a source_pos into a valid VIM edit command
function source2view() {
  cat -- | awk -F":" '{print ":vie +"$2" "$1}'
}

if [ "$VIM_TRACEOPEN_SH" == $( basename $0 ) ]; then
  #Not sourced, do something with this.

#echo "$1"
source_pos "$1"
#exit 0

  if [ ! -f jpacks ]; then
    echo "No \"jpacks\" file found. Please create one, see:"
    echo "http://mibwiki.sonyericsson.net/index.php/MiB_Michael_Ambrus#Generate_a_packages_file_to_search_in"
    exit -1
  fi
  vim $(source_pos "$1" | sed -e 's/:/ +/')
fi

unset VIM_TRACEOPEN_SH
