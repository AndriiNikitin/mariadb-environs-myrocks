#!/bin/bash
[[ -d __srcdir ]] || mkdir -p __srcdir
[[ -d __blddir ]] || mkdir __blddir



cd __srcdir
if [ __branch == master ] ; then
  git clone --depth=1 https://github.com/facebook/mysql-5.6 .
else
  git clone --depth=1 https://github.com/facebook/mysql-5.6 -b __branch .
fi

cd __srcdir
git pull
