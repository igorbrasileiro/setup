#!/bin/bash

# Script to prune remote branches and delete local branches that no longer exist on remote
# Author: Igor Brasileiro
# Created: 2025-05-09

echo "Fetching and pruning remote branches..."
git fetch -p

echo "Detecting and removing local branches that no longer exist on remote..."
for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
  echo "Deleting local branch: $branch"
  git branch -D "$branch"
done

echo "Done! Your git branches are now clean."
