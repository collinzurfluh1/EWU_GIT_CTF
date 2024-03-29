#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f coolscript.py ];
        then reject-solution "Ayo what happened to coolscript.py???";
    fi
    
    if [ ! -f coolestscript.py ];
        then reject-solution "Hmmm seems like the merge didn't go right. Are you sure you merged?";
    fi
    
    echo "Trying to execute the script ./coolscript.py..."
    echo

popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 2 ]; then
    reject-solution "Pushed commit isn't a merge commit! Saw only $how_many_parents for this commit, expected 2. Try again."
fi
