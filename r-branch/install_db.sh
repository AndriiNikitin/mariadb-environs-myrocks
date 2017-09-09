#!/bin/bash
bash __srcdir/scripts/mysql_install_db.sh --defaults-file=__workdir/my.cnf --datadir=__workdir/dt --user=$(whoami) --builddir=__blddir --srcdir=__srcdir --force

