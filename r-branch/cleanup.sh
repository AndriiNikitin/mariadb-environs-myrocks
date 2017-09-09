#!/bin/bash
__workdir/kill9.sh
[ -f __workdir/my.cnf ] && __blddir/client/mysqladmin --defaults-file=__workdir/my.cnf shutdown 2>/dev/null && sleep 5

rm -rf __datadir/*
rm -f __workdir/my.cnf
