#!/bin/bash

CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$CURRENT_BRANCH" != "olc" ]; then
    if [[ `git status --porcelain` ]]; then
        echo "You appear to have changes in your current branch."
        exit 1
    fi
fi

git checkout olc
git pull
git rebase origin/main
CONTAINER=$(sudo docker ps -q --filter volume=asteria_zones --filter volume=asteria_data)
sudo docker cp $CONTAINER:/home/asteria/data $PWD
sudo docker cp $CONTAINER:/home/asteria/zones $PWD
sudo find ~ -type d -user root -exec sudo chown -R $USER: {} +
git add data zones

if [[ -z $(git diff --staged) ]]; then
    echo "No changes to the data or zones directories were found. Exiting."
    exit 0
fi

COMMIT_MESSAGE="$@"
if [[ -z "$COMMIT_MESSAGE" ]]; then
    echo "No commit message provided. Using default commit message."
    COMMIT_MESSAGE="OLC commit"
fi

git commit -m "$COMMIT_MESSAGE"
git push