#!/bin/bash
# DATADIR=__workdir/dt
MYSQLD_DATADIR=__workdir/dt
# mysql_datadir=$DATADIR
MYSQL_BLDDIR=__blddir
MYSQL_SRCDIR=__srcdir 

MYSQL_EXTRA_CNF=__workdir/mysqldextra.cnf
MYSQL_BASEDIR=__blddir

[ -f __blddir/extra/mariabackup//mariabackup ] && alias xtrabackup="__blddir/extra/mariabackup//mariabackup"
[ -f __blddir/extra/mariabackup//mbstream ]    && alias xbstream="__blddir/extra/mariabackup//mbstream"
[ -f __blddir/extra/mariabackup//mariabackup ] && alias innobackupex="__blddir/extra/mariabackup//mariabackup --innobackupex"
alias mysqld="__blddir/sql//mysqld"
alias mysql="__blddir/client//mysql --defaults-file=__workdir/my.cnf"
alias mysqladmin="__blddir/client//mysqladmin --defaults-file=__workdir/my.cnf"
alias mysqldump="__blddir/client//mysqldump --defaults-file=__workdir/my.cnf"
alias mysql_install_db="__srcdir/scripts/mysql_install_db.sh"
# export PATH=$PATH:/__blddir/extra/xtrabackup/

shopt -s expand_aliases

MYSQL_VERSION="$(mysqld --no-defaults --version)"
MYSQL_VERSION=${MYSQL_VERSION#*Ver }
MYSQL_VERSION=${MYSQL_VERSION%-*}

if [ -f __workdir/config_load/configure_innodb_plugin.sh ] \
 || [[ $MYSQL_VERSION == 10.2* ]] \
 || [[ $MYSQL_VERSION == 10.3* ]] \
 || [[ $MYSQL_VERSION == 5.6* ]] \
 || [[ $MYSQL_VERSION == 5.7* ]] 
then
  INNODB_VERSION=$MYSQL_VERSION
  XTRADB_VERSION=""
else
  INNODB_VERSION=""
  XTRADB_VERSION=$MYSQL_VERSION
fi
