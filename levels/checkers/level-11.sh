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
    chmod +x coolscript.py
    ./coolscript.py

    if [[ $(./coolscript.py) != *"If Cinderella’s shoe fit perfectly"* ]] || [[ $(./coolscript.py) != *"Friends buy you food"* ]] || [[ $(./coolscript.py) != *"Some people are like clouds"* ]] ; then
        reject-solution "Seems like the script isn't printing all the required resources. It should print a Git Koan, a quote about flags, and a quote about git."
    fi

    if [ -f add_resources.sh ];
        then reject-solution "add_resources is still here! You should have deleted it in the topic branch...";
    fi
popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 1 ]; then
    reject-solution "Pushed commit is a merge commit! Saw $how_many_parents parents for this commit, expected 1. Try again - the history should be linear."
fi

log_n=10
echo "git log of last $log_n commits..."
git log --decorate --oneline --graph -n $log_n $new
