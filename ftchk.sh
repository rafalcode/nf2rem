#!/bin/bash

EXPECTED_ARGS=1 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
    REM="ks3298968.kimsufi.com"
    >&2 echo "No remote server given, shall use $REM"
else
    REM=$1
fi
U=nutria
P=navarra
CFL=`ftp -n $REM <<END_SCRIPT | grep -Po "[^ ]+$"
quote USER $U
quote PASS $P
cd nf2rem
ls
quit
END_SCRIPT
`
CFLA=( $CFL )
2>&1 echo "Length of remote file listing is ${#CFLA[@]}"

# Past file listing: note this is a remote file listing.
PF2=~/crologs/rnf2.lst
if [ ! -e $PF2 ]; then
    echo "Error: $PF2 must exist for this program to run" && exit
fi

# generate a hash file listing of the past filenames.
declare -A PFA
for i in `cat $PF2`; do
    PFA[${i}]=1
done

# OK< now we can compare the Current file list to the Past FIle list
for f in ${CFLA[@]}; do
    if [[ "${PFA[$f]}" != 1 ]]; then
        echo "$f is a new file"
    fi
done
