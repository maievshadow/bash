#! /bin/bash 
echo "git is running...>>>"
git status
git branch
git pull origin $3
git add $1
git commit -m'$2'
git push origin $3
echo "##end push";
exit 0;
