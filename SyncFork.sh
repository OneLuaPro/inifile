#!/bin/bash

# repo from which this fork was made
or="https://github.com/bartbes/inifile.git"

# get basename of current dir
bn=$(basename $(pwd))
# check if basename is in current list of remotes
rn=$(git remote | grep $bn)

if [ "$bn" = "$rn" ]; then
	echo "Original remote repo found."
else
	echo "Adding original remote repo."
	git remote add $bn $or 
fi

git checkout develop
git pull origin develop
git fetch $rn
git merge $rn/develop
git push origin develop

read -p "Press enter to close window"
