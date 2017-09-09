#!/bin/bash
[ -f common.sh ] && source common.sh

[[ -d __blddir ]] || mkdir __blddir

cd __blddir
cmake __srcdir -DCMAKE_BUILD_TYPE=RelWithDebInfo -DWITH_SSL=system \
-DWITH_ZLIB=bundled -DMYSQL_MAINTAINER_MODE=0 -DENABLED_LOCAL_INFILE=1 \
-DENABLE_DTRACE=0 -DCMAKE_CXX_FLAGS="-march=native" 
