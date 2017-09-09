#!/bin/bash
__blddir/client/__bldtype/mysql --defaults-file=__workdir/my.cnf -BN -e "$*" test
