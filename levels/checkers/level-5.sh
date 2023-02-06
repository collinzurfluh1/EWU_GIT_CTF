#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    # Check file existence.
    if [ ! -f windowsSucks.txt ];
        then reject-solution "windowsSucks.txt is missing! Try again.";
    fi

    if [ ! -f macRocks.txt ];
        then reject-solution "macRocks.txt is missing! Try again.";
    fi

    if [ -f linUxIsCoOl.txt ];
        then reject-solution "Incoming Message: theres a secret mission and we have to remove linUxIsCoOl.txt from git and commit again and push.";
    fi
popd

# We know that there's only one commit in the changes - otherwise it would have failed before.
number_of_files_changed=$( git diff --stat $old $new | grep "files changed" | awk ' {print $1} ' )
if [[ $number_of_files_changed -ne 2 ]]
    then reject-solution "More than 2 files was changed! Only add windowsSucks.txt and macRocks.txt";
fi
