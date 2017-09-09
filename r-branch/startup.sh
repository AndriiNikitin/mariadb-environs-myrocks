#!/bin/bash
__blddir/sql/__bldtype/mysqld --defaults-file=__workdir/my.cnf --user=$(whoami) $* & 
__workdir/wait_respond.sh
