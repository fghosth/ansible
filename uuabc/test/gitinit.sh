#!/bin/bash
touch README.md
git init
git add README.md
git commit -m "first commit"
git remote add origin http://git.uab.com/uuabc/backend.git
git push -u origin master
