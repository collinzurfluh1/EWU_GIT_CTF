#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f coolscript.py ];
        then reject-solution "coolscript.py is missing.";
    fi

    if [ -f dummyscript.py ];
        then reject-solution "You didnt revert the merge correctly.";
    fi

    if [ -f differentscripts.py ];
        then reject-solution "You didnt revert the merge correctly.";
    fi

popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 3 ]; then
    reject-solution "You must not have merged and done a merge revert.."
fi

log_n=5
echo "git log of last $log_n commits..."
git log --oneline --graph -n $log_n $new
