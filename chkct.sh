#!/bin/bash
# check user's crontab

EXPECTED_ARGS=0 # change value to suit!
# some quick "argument accounting"
if [ $# -ne $EXPECTED_ARGS ]; then
        echo "Correct usage: $1 <destination_directory>"
        exit
fi

CT=`crontab -l`

# we can skip crontab -l output with comments .. but we splitting only on enwlines, not just any space.
# so we temporarily dible the IFS< the Input file separator
set -f # turn off globbing
IFS='
'

# we'll just do some rought matching to see if our crontab's are there.
NFGF="nf2gen\.sh"
FLP="crologs/nf2.lst"

for i in $CT; do
    # don't worry about sytax coloring goign awry here ... it's fine.
    [[ "$i" =~ ^#.*$ ]] && continue
    if [[ $i =~ $NFGF ]] ; then
        echo "OK, current user's crontab set up for unique file, random line generation ($NFGF)"
    fi
    if [[ $i =~ $FLP ]] ; then
        echo "OK, current user's crontab set up for file with listing of files in (${FLP})"
    fi
done
# restore IFS
unset IFS
set +f
