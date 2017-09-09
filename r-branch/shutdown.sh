#!/bin/bash
set -e
__blddir/client/__bldtype/mysqladmin --defaults-file=__workdir/my.cnf shutdown
if [ -f __workdir/dt/p.id ]
then
  pid=$(cat __workdir/dt/p.id 2>/dev/null)
  [ -z "$pid" ] || for i in {1..100} ; do
    [ $i -le 99 ] || { >&2 echo 'Failed to stop mysqld with pid $pid'; exit 1; }
    sleep 1
    [ -z "$(ps auxw | grep -- mysqld | grep -- $pid)" ] || break
    echo "Process $pid still exists, sleeping 1 sec"
  done
fi

