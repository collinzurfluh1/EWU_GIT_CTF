#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f coolscript.py ];
        then reject-solution "coolscript.py is missing.";
    fi

    if [ ! -f myfile.txt ];
        then reject-solution "HEY! You didnt follow the directions... Add the file required in README.md";
    fi

    if [ ! -f coolestscript.py ];
        then reject-solution "Hmm seems like you're missing a file from the merge.";
    fi

    if [ -f .spyware ];
        then reject-solution "You're telling me you STILL have spyware on your repo?!? Remove the spyware.";
    fi

    echo "Trying to execute the script ./coolscript.py..."
    echo
    
    # Will raise the following if conflicts weren't resolved:
    #   File "./runme.py", line 11
    # <<<<<<< HEAD
    # ^
    # IndentationError: expected an indented block
    chmod 777 coolscript.py
    ./coolscript.py

    if [[ $(./coolscript.py) == *"Never gonna giv u up neva gonna let u dowwwnnnn never gonna run around and desert you"* ]] ; then
        reject-solution "Seems like the script still prints the mistake."
    fi
    if [[ $(./coolscript.py) != *"Never gonna give you up never gonna let you down never gonna run around and desert you."* ]] ; then
        reject-solution "Seems like the merge didn't go right - the error still persists."
    fi
popd

how_many_parents=$(how_many_parents $new)
if [ $how_many_parents -ne 1 ]; then
    reject-solution "Pushed commit isn't a merge commit! Saw only $how_many_parents for this commit, expected 2. Try again."
fi

log_n=5
echo "git log of last $log_n commits..."
git log --oneline --graph -n $log_n $new
