#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-09-21

# This script finds make variables by simplistic parsing. It produces a list
# with both variable, file-reference and right-hand values on a single row.
# By greping in the output for a right-hand value, the corresponding make-file
# can then easily be found. Especially good for finding right-hand
# values defined by more than one variable in for example Android.

# Some useful make-variables in Android interesting to use this script on:
# PRODUCT_AAPT_CONFIG
# PRODUCT_AAPT_PREF_CONFIG
# PRODUCT_BRAND
# PRODUCT_CHARACTERISTICS
# PRODUCT_COPY_FILES
# PRODUCT_DEFAULT_PROPERTY_OVERRIDES
# PRODUCT_DEVICE
# PRODUCT_LOCALES
# PRODUCT_MAKEFILES
# PRODUCT_MANUFACTURER
# PRODUCT_MODEL
# PRODUCT_NAME
# PRODUCT_PACKAGE_OVERLAYS
# PRODUCT_PACKAGES
# PRODUCT_PROPERTY_OVERRIDES
# PRODUCT_SDK_ADDON_COPY_FILES
# PRODUCT_SDK_ADDON_COPY_MODULES
# PRODUCT_SDK_ADDON_DOC_MODULES
# PRODUCT_SDK_ADDON_NAME
# PRODUCT_SDK_ADDON_STUB_DEFS
# PRODUCT_TAGS

if [ -z $MDEF_SH ]; then

MDEF_SH="mdef.sh"

# Lexer. Looks for start of varable asignement. Variable needs to start on
# begining of line to be considered valid.
AWK1='
	BEGIN{
		ingroup=0
		CNTR=1
		nextvalid=0
	}
	{
		if (!ingroup) {
			if (index($0,PATTERN) == 1){
				printf("%s;%d;",FNAME,CNTR);
				ingroup=1
				print $0
			
				nextvalid=0
				if (match($0,"\\\\[[:space:]]*$")){
					nextvalid=1
				} else {
					ingroup=0
					nextvalid=0
				}

			}
		} else {
			if (nextvalid) {
				#This is last iterations nextvalid
				print $0
			}
			nextvalid=0
			if (match($0,"\\\\[[:space:]]*$")){
				nextvalid=1
			} else {
				ingroup=0
				nextvalid=0
			}
		}
		CNTR++
	}
'

# No right hand value on same line. Add +1 to line number
AWK2='
	/^\./{
		printf("\n")
		if (match($0,"=[[:space:]]\\\\[[:space:]]*$")){
			print $1";"$2 + 1";"$3
		} else {
			print $0
		}
	}
	/^[[:space:]]/{
		print $0
	}
'

# Don't line-break if line ends with '\'
AWK3='
	{
		if (match($0,"\\\\[[:space:]]*$")){
			printf("%s",$0);
		} else
			print $0
	}
'

function mdef() {
	FS=$(src.mgrep.sh ${1} | cut -f1 -d":" | sort -u)
	for F in $FS
	do
		cat $F | \
			awk -vFNAME=${F} -vPATTERN=${1} "${AWK1}" | \
			awk -F";" "${AWK2}" | \
			awk "${AWK3}" | \
			sed -e 's/\\//g' | \
			sed -e 's/[[:space:]]\+/ /g' | \
			sed -e 's/[[:space:]]\+$//' | \
			awk '/[[:graph:]]/{print $0}'
	done
}


source s3.ebasename.sh
if [ "$MDEF_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	mdef "$@"

	exit $?
fi

fi
