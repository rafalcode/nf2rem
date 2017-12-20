#!/bin/bash

EXPECTED_ARGS=1 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
    # REM="ks3298968.kimsufi.com"
    # REM="chpc-hf63-3.st-andrews.ac.uk"
    REM="vps226116.ovh.net"
    >&2 echo "No remote server given, shall use $REM"
else
    REM=$1
fi
U=nutria
PF=~/crologs/p66.txt
if [ ! -e $PF ]; then
    echo "Error: You need a local password file called $PF"
fi
P_=`cat $PF`
P="${P_%\\n}"
CFL=`ftp -n $REM <<END_SCRIPT | grep -Po "[^ ]+$"
quote USER $U
quote PASS $P
cd nf2rem
ls
quit
END_SCRIPT
`
CFLA=( $CFL )

# Past file listing: note this is a remote file listing.
PF2=~/crologs/hfnf.lst
if [ ! -e $PF2 ]; then
    echo "Error: $PF2 must exist for this program to run" && exit
fi

# generate a hash file listing of the past filenames.
declare -A PFA
for i in `cat $PF2`; do
    PFA[${i}]=1
done

# OK. now we can compare the Current file list to the Past File list
NWF=()
for f in ${CFLA[@]}; do
    if [[ "${PFA[$f]}" != 1 ]]; then
        NWF+=($f)
    fi
done
LDEST=~/nf2rem
2>&1 echo "Of a total ${#CFLA[@]} files on remote computer, ${#NWF[@]} are new and will be downloaded to $LDEST"

# We prefer to render the array contents onto a single string for ftp operations.
# Call this string A or $A
for nf in ${NWF[@]}; do
    A+=$nf
done

if [ "$A" != "" ]; then
ftp -n $REM <<END_SCRIPT2
quote USER $U
quote PASS $P
lcd $LDEST
cd nf2rem
get $A
quit
END_SCRIPT2
fi

# With the new file copied over, we can update the Past File Listing so that it is not downloaded again
# and in passing calculate the number of lines it has.
for nf in ${NWF[@]}; do
    cwc=`wc -l ${LDEST}/$nf |cut -d' ' -f1`
    echo "Copied over $nf number lines $cwc ... adding to Past Filelisting $PF2"
    echo $nf >> $PF2
done
