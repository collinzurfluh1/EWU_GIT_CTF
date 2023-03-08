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

    # Will raise if not merged
    ./coolscript.py
popd

# Check that merge was fast forward merge.
new_commit=$(get_commit_of $new)
target_commit=$(get_commit_of mergehelper1-tag)
if [ "$new_commit" != "$target_commit" ]; then
    reject-solution "Merge should have been a fast-forward merge. Try again."
fi
