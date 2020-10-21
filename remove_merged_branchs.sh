#!/bin/bash

branches=`git branch --merged | egrep -v "(^\*|master|beta|dev)"`
if [[ branches -eq "" ]]
then
    echo "You don't have merged branches"
else
    echo "These branches have been merged:"
    echo "${branches}"
    read -p "Are you sure? " -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo 'Removing...'
        git branch --merged | egrep -v "(^\*|master|beta|dev)"  | xargs git branch -d
        echo "Done!"
    fi
fi
