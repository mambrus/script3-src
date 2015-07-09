#!/bin/bash
# Author: Michael Ambrus (michael.ambrus@sigmaconnectivity.se)
# 2015-07-09

if [ -z $DTFILES_SH ]; then

DTFILES_SH="dtfiles.sh"

# Find dts-files according to pattern passed as $1 and print this to stdout
# Parse each file and append-write all found includes to filename passed as
# $2
function find_dtsfile() {
	local AFILE=$1
	local INCLUDE_FILES_FNAME=$2

	for F in $( find . -name $(basename $AFILE) | grep $(dirname $AFILE) ); do
		echo $F;
		grep -e '^.include' $F | \
			awk '{print $2}' | \
			sed -e 's/"//g' -e 's/[<>]//g' >> \
				"${INCLUDE_FILES_FNAME}"
	done
}

function dtfiles() {
	source futil.tmpname.sh
	tmpname_flags_init "-a"

	find_dtsfile $1 $(tmpname 0)

	for (( doloop=1, i=0; doloop; i++ )); do
		for F in $(cat $(tmpname $i)); do
			#echo "$i: $F" 1>&2
			if [[ "$F" =~ ^.*\.dts|^.*\.dtsi ]]; then
				find_dtsfile $F $(tmpname unsorted_$((i+1)) )
			else
				#Not a DT file. Just search for it, don't parse.
				find . -name $(basename $F) | grep $(dirname $F)
			fi
		done
		sort -u $(tmpname unsorted_$((i+1)) ) > $(tmpname $((i+1)) )

		if [ "X$(cat $(tmpname $((i+1)) ) | wc -l)" == "X0" ]; then
			doloop=0
		fi

	done
	tmpname_cleanup
}

source s3.ebasename.sh
if [ "$DTFILES_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	DTFILES_SH_INFO=${DTFILES_SH}
	source .src.ui..dtfiles.sh

	dtfiles "$@"

	exit $?
fi

fi
