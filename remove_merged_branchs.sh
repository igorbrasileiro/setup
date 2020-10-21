#!/bin/bash

branches=`git branch --merged | egrep -v "(^\*|master|beta|dev)"`
echo "These branches have been merged:"
echo "${branches}"
read -p "Are you sure? " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo
    echo 'Removing...'
    git branch --merged | egrep -v "(^\*|master|beta|dev)"  | xargs git branch -d
    echo "Done!"
    exit 1
fi
