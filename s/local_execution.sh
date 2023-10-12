#!/bin/bash

# A hypothetical script for running in local mode with a local ssh key for git access.

# When we hit a ctrl+c, forward it to the running process then continue script execution.
trap ' ' INT

# Switch to the OLC branch for any changes made by the mud itself to its data directories.
git checkout olc

# Run the MUD
if $PWD/asteria ; then
    echo "Asteria closed gracefully."
else
    RESULT=$?
    if [ $RESULT -eq 130 ]; then
        echo "Asteria closed by request."
    else
        echo "Asteria crashed with exit code $RESULT"
    fi
fi

# Perform an emergency commit if we've exited the mud with changes in data or zones
if [[ `git status data zones --porcelain` ]]; then
    echo "Uncommitted changes found in data directories. Attempting to upload to the olc branch."
    git add data zones
    git commit -m "Automatic end-of-execution commit"
    git push
else
    echo "No uncommited changes found in data directories."
fi