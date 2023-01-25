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

# Check how many commits the user needed - should be two (the user commit + merge commit)!
commit_amount=$( git log level-1..$new --oneline | wc -l )
if [ $commit_amount -ne 1 ];
    then reject-solution "The files should have been added in a single commit, but I've found ${commit_amount} commits in the log. To reset and try again, delete your local start-here branch, checkout the original start-here branch again and try again.";
fi

# We know that there's only one commit in the changes - otherwise it would have failed before.
number_of_files_changed=$( git diff --stat $old $new | grep "files changed" | awk ' {print $1} ' )
if [[ $number_of_files_changed -ne 1 ]]
    then reject-solution "More than 1 files were changed! Only add computerScienceRocks.txt. Check out the original branch and try again.";
fi
