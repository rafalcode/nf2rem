#!/bin/bash
# we want to create a new file with a randomly a varying number of lines
# in a certain directory

EXPECTED_ARGS=1 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
        echo "Correct usage: $1 <destination_directory>"
        exit
fi

# we want a small range varying number
NL=$((1+${RANDOM}%5))
# also want a unique output file name (OF): combine current mintues, second and a random number
OF=nf_$(date +%M%S)_${RANDOM}.csv

# our destination directory is our first argument
DEST=$1
LD=~/crologs/nf2.log

if [ ! -d $DEST ]; then
    echo "$DEST not found"
else
    echo "OK, $DEST exists"
fi

# use typical bash tools to generate a file with a (slightly) varying number of lines
seq $NL | xargs -I -- echo "$HOSTNAME says hello" > ${DEST}/${OF}

# see how many lines it has
N=`wc -l ${DEST}/${OF} | cut -d' ' -f1`
# send verifying message.
if [ ! -f $LD ]; then
    echo "$LD not found"
else
    echo "OK, $LD exists"
fi

echo "OK, random ${N}-line file called ${OF} created in ${DEST}" >> $LD
