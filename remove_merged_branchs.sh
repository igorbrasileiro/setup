#!/bin/bash

branches=`git branch --merged | egrep -v "(^\*|master|beta|main)"`
if [[ branches -eq "" ]]
then
    echo "You don't have merged branches"
else
    echo "These branches have been merged:"
    echo "${branches}"
    
    read -r -p "Press [Y/yes] if you want to remove all these branches above. " response;echo

    if [[ "$response" =~ ^(Y)*$ || "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo "Removing..."
        git branch --merged | egrep -v "(^\*|master|beta|main)"  | xargs git branch -d
        echo "Done!"
    fi
fi
