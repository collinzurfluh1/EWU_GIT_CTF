#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f coolscript.py ];
        then reject-solution "coolscript.py is missing.";
    fi

    echo "Trying to execute the script ./coolscript.py..."
    echo
    
    chmod 777 coolscript.py
    ./coolscript.py

    if [[ $(./coolscript.py) != *"The coolest text you can find."* ]] ; then
        reject-solution "Theres an error in this code. Use git revert to revert your changes. Then push that code."
    fi
popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 1 ]; then
    reject-solution "There should only be 1 commit."
fi

log_n=5
echo "git log of last $log_n commits..."
git log --oneline --graph -n $log_n $new
