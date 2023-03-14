#!/bin/bash

source $(dirname $0)/checkers-lib.sh

read old new ref < /dev/stdin

dump_dir=$(dump-commit-to-directory $new)

pushd $dump_dir
    if [ ! -f mergerscript.py ];
        then reject-solution "mergerscript.py is missing.";
    fi

popd

# Check that merge was fast forward merge.
new_commit=$(get_commit_of $new)
target_commit=$(get_commit_of mergehelper4-tag)
if [ "$new_commit" != "$target_commit" ]; then
    reject-solution "Merge should have been a fast-forward merge. Try again."
fi
