#!/bin/bash
# Opens stacktrace
#
# Author: Michael Ambrus ambrm09@gmail.com 
# Date: Nov 20, 2009


set -e
set -u
SNAME=$(basename "$1")
if [ $# -eq 2 ]; then
  SNAME=${SNAME}_$2
fi
STARTKATE_SH="startkate_${SNAME}.sh"

declare -i LIST_STARTS=$(grep -ne 'FILE:LINE' <  $1 | cut -f1 -d":")
#declare -i KEEP_BOTTON_LINES=$(( $(wc -l < "$1") - "$LIST_STARTS" ))
declare -i NLINES=$(wc -l < "$1")
declare -i KEEP_BOTTON_LINES=$(( $NLINES - $LIST_STARTS ))
declare FNAME=$(basename $1)
if [ $# -eq 2 ]; then
  FNAME=${FNAME}_$2
fi

echo '#!/bin/bash' > "$STARTKATE_SH" 
echo "# NOTE: This is file was auto-generated $(date "+%y%m%d_%H%M%S"). IT WILL BE OVERWRITTEN!" >> "$STARTKATE_SH"
echo "# ==============================================================================" >> "$STARTKATE_SH"
echo "kate -s $FNAME -u $1 >/dev/null 2>&1 &" >> "$STARTKATE_SH"
echo "sleep 1" >> "$STARTKATE_SH"  


echo "kate -s $FNAME -u $(dirname "$1")/TOMBSTONE >/dev/null 2>&1 &" >> "$STARTKATE_SH"
echo "sleep 1" >> "$STARTKATE_SH"
echo "kate -s $FNAME -u $(dirname "$1")/STACKLIST >/dev/null 2>&1 &" >> "$STARTKATE_SH"
echo "sleep 1" >> "$STARTKATE_SH"
echo "kate -s $FNAME -u $(dirname "$1")/STACKLIST_COMP >/dev/null 2>&1 &" >> "$STARTKATE_SH"
echo "sleep 1" >> "$STARTKATE_SH"


tail -n $KEEP_BOTTON_LINES < "$1" 		| \
  sed -e 's/.* //' 				| \
  sed -e 's/:/ -l /' 				| \
  sed -e 's/$/ >\/dev\/null 2>\&1 \&/' 		| \
  sed -e "s/^/kate -s $FNAME -u /"		| \
  grep -v 'u ??' 				| \
  awk '{print; printf "sleep 1\n"}' 		>> \
  "$STARTKATE_SH" 


chmod a+x "$STARTKATE_SH"
#./"$STARTKATE_SH"
