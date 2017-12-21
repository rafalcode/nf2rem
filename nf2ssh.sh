#!/bin/bash
# nf2sftp.sh new files in a remote machine are copied locally to ~/nf2rem

EXPECTED_ARGS=1 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
    # REM="ks3298968.kimsufi.com"
    REM="chpc-hf63-3.st-andrews.ac.uk"
    # REM="vps226116.ovh.net"
    >&2 echo "No remote server given, shall use $REM"
else
    REM=$1
fi

CFL=`ssh $REM 'ls nf2rem'`
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
# if a file in the current file listing does not has to 1, it is new, store it in NWF.
NWF=()
for f in ${CFLA[@]}; do
    if [[ "${PFA[$f]}" != 1 ]]; then
        NWF+=($f)
    fi
done

for i in ${NWF[@]}; do
    scp $REM:~/nf2rem/$i ~/nf2rem
    echo $i >> $PF2
    WCL=`wc -l ~/nf2rem/$i | cut -d' ' -f1`
    echo "$i with $WCL lines copied and appended to Past File Listing"
    # email subject
    EMSUB="${i}_${WCL}"
    echo "no body text" | mail -s $EMSUB stabudesk@gmail.com
done
