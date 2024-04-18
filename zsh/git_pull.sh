#!/usr/bin/env bash

git stash -a
git checkout mega
git pull
git checkout dms
git rebase mega
git stash pop
