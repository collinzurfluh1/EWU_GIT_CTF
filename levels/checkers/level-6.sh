#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    # Check file existence.
    if [ ! -f antiSpyAgency.txt ];
        then reject-solution "antiSpyAgency.txt is missing! Try again.";
    fi

    if [ -f .spyware ];
        then reject-solution "Incoming Message: theres a secret mission and we have to remove .spyware from git and commit again and push.";
    fi
popd

# We know that there's only one commit in the changes - otherwise it would have failed before.
number_of_files_changed=$( git diff --stat $old $new | grep "files changed" | awk ' {print $1} ' )
echo "Files changed:";
echo $number_of_files_changed;

if [[ $number_of_files_changed -ne 1 ]]
    then reject-solution "More than 1 files was changed! Only add antiSpyAgency.txt.";
fi
