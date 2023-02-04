#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    # Check file existence.
    if [ ! -f level4Pro.txt ];
        then reject-solution "level4Pro.txt is missing! Try again.";
    fi

    if [ -f level4Noob.txt ];
        then reject-solution "Incoming Message: theres a secret mission and we have to remove level4Noob.txt from git and commit again and push. ex: git rm level4Noob.txt.";
    fi
popd

# We know that there's only one commit in the changes - otherwise it would have failed before.
number_of_files_changed=$( git diff --stat $old $new | grep "files changed" | awk ' {print $1} ' )
if [[ $number_of_files_changed -ne 1 ]]
    then reject-solution "More than 1 files was changed! Only add level4Pro.txt.";
fi
