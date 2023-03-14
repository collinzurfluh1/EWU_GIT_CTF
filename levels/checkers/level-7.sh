#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f mergedscript.py ];
        then reject-solution "Oops looks like the merge didnt work. Are you sure your merged?";
    fi
    
    if [ ! -f coolscript.py ];
        then reject-solution "What happened to coolscript.py?!?";
    fi

popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 2 ]; then
    reject-solution "Pushed commit isn't a merge commit! Saw only $how_many_parents for this commit, expected 2. Try again."
fi
