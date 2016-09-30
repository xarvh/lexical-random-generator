#!/bin/bash

ADD=index.html


CURRENT_BRANCH=`git rev-parse --abbrev-ref HEAD`

if [ "$CURRENT_BRANCH" = "" ]; then
    echo No current branch
    exit 1
fi

if [ "$CURRENT_BRANCH" = "gh-pages" ]; then
    echo Error: current branch is gh-pages
    exit 2
fi

git branch -D gh-pages
git checkout -b gh-pages

cd $(dirname $0)/examples
elm-make --yes Starships.elm --output=../index.html
cd ..

git add -f $ADD
git commit -m Publish
git push -f origin gh-pages

git checkout $CURRENT_BRANCH
