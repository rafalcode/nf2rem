#!/bin/bash
# nf2chk.sh new file 2 check
# will check in a specified directory for a new file
# NOTE: there must be a plain (past) file listing in ~/crologs/nf2.lst to compare with
# we want to create a new file with a randomly a varying number of lines
# in a certain directory

EXPECTED_ARGS=1 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
        echo "Correct usage: $1 <destination_directory>"
        exit
fi

# our destination directory is our first argument
DEST=$1

if [ ! -d $DEST ]; then
    echo "Error: $DEST must exist for this program to run" && exit
fi

# Past file listing
PF2=~/crologs/nf2.lst
if [ ! -e $PF2 ]; then
    echo "Error: $PF2 must exist for this program to run" && exit
fi

# We are going to match up a current file listing with a past file listing
# hashing is usually the speediest way to do this.
# So let's create a hash (associative array) of the Past File Listing

declare -A PFA
for i in `cat $PF2`; do
    PFA[${i}]=1
done

#debug, list out assoc array
# PFAL=${#PFA[@]}
# echo "Past file listing is $PFAL in length"
# for i in "${!PFA[@]}"; do
#    echo $i
#    echo ${PFA[$i]}
# done

# CFL current file list
CFL=`ls -1tr ${DEST}`
for f in $CFL; do
    if [[ "${PFA[$f]}" != 1 ]]; then
        echo "$f is a new file"
    fi
done
