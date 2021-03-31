#! /bin/bash

echo "Update vimrc script"

echo "Copying .vimrc from home to here"
cp ~/.vimrc .

echo "Commiting and pushing"
git add .vimrc
git commit -m "Update .vimrc"
git branch --show-current | xargs git push origin
