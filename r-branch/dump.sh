#!/bin/bash
if [ "$#" -eq 0 ]; then 
  __blddir/client/mysqldump --defaults-file=__workdir/my.cnf --all-databases
else
  __blddir/client/mysqldump --defaults-file=__workdir/my.cnf "$@"
fi
