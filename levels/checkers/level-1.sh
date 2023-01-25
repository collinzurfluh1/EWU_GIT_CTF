#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    # Check file existence.
    if [ ! -f computerScienceRocks.txt ];
        then reject-solution "computerScienceRocks.txt is missing! Try again.";
    fi
popd

# We know that there's only one commit in the changes - otherwise it would have failed before.
number_of_files_changed=$( git diff --stat $old $new | grep "files changed" | awk ' {print $1} ' )
if [[ $number_of_files_changed -ne 1 ]]
    then reject-solution "More than 1 file was changed! Only add computerScienceRocks.txt. Check out the original branch and try again.";
fi
