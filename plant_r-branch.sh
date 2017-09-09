#!/bin/bash

# Generate scripts for mariadb environs for source distribution / github source branch
# if git branch is detected - some additionl scripts are generated
# Example usage:
# $1 m1-10.2-mybranch - will generate scripts to clone source into _deport/m-branch/10.2-mybranch 
#                       and build directory m1-10.2-mybranch/build 
# $1 m1 ~/mysrc ~/mybld - will generate scritps to build in ~/mybld from ~/mysrc

# Parameters:
# $1 envirins directory or environ id (e.g. m1-10.2-mybranch or m1)
# $2 (only when $1 doesn't contain branch, only environ id) - existing source directory
# $3 (only if $2 present) - build directory (if differes from $2)

set -e

. common.sh

# extract worker prefix, e.g. m12
wwid=${1%%-*}
# extract number, e.g. 12
wid=${wwid:1:100}

port=$((3706+$wid))

if [ "$#" -gt 1 ] ; then
# [ ! -z "$2" ] || { >&2 echo "Expected source directory as second parameter"; exit 2; }
# if ls ${wwid}* 1> /dev/null 2>&1; then
#   >&2 echo "Environ $wwid already has directory - expected free environ id"; 
#    exit 2;
#  fi
  src=$2
  bld=${3-$src}

  # try to determime branch, if it is empty - no git scrips should be generated
  branch=$(cd $src && git branch 2>/dev/null | grep \* | cut -d ' ' -f2 )
else
  workdir=$(find . -maxdepth 1 -type d -name "$wwid*" | head -1)
  [[ -d $workdir ]] || {  >&2 echo "Directory must exists in format $wwid-branch"; exit 1; }

  # if worker folder exists - it must be empty or have only two empty directories (those may be mapped by parent farm for docker image)
  if [[ -d $workdir ]]; then
    ( [[ -d $workdir/dt && "$(ls -A $workdir/dt)" ]] \
    || [[ -d $workdir/bkup && "$(ls -A $workdir/bkup)" ]] \
    || [[ "$(ls -A $workdir | grep -E -v '(^dt$|^bkup$)')" ]] \
    ) && {>&2 echo "Non-empty $workdir aready exists, expected unassigned worker id"; exit 1;}
  fi
  [[ $workdir =~ ($wwid-)(.*)$ ]] || {>&2 echo "Couldn't parse format of $workdir, expected $wwid-branch"; exit 1;}

  branch=${BASH_REMATCH[2]}

  src=$(pwd)/_depot/r-branch/$branch

  # check if source directory is not empty
#  if [[ ! -z "$src" ]] && [[ -d "$src" ]] && ls -A ${src} &>/dev/null; then
#    srcbranch=$(cd $src && git branch | grep \* | cut -d ' ' -f2)
#    [[ -z $branch ]] || [[ $branch == $srcbranch ]] || {>&2 echo "Actual branch $srcbranch doesn't match $branch" ; exit 1;}
#  fi
fi

workdir=$(pwd)/$wwid
[ -z "$branch" ] || workdir=$workdir-$branch

[[ -d $workdir ]] || mkdir $workdir
[[ -d $workdir/dt ]] || mkdir $workdir/dt
[[ -d $workdir/bkup ]] || mkdir $workdir/bkup

[ ! -z "$bld" ] || bld=$workdir/build

[[ -d $src ]] || mkdir -p $src || {>&2 echo "Cannot create source directory $src" ; exit 1;}


# detect windows like this for now
case "$(expr substr $(uname -s) 1 5)" in 
  "MINGW"|"MSYS_")
    dll=dll
    bldtype=Debug ;;
  *)
    dll=so ;;
esac

[ -d _template/r-branch ] && for filename in _template/r-{branch,all}/* ; do
 # generate scripts with __branch only if $branch is not empty
  if [ -z "$branch" ] && grep -q __branch $filename ; then
    :
  else
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
  fi
done


if [[ $dll != "dll" ]]; then
  for filename in _template/r-{branch,all}/*.sh ; do
    [ -f $workdir/$(basename $filename) ] && chmod +x $workdir/$(basename $filename)
  done
fi

# do the same for enabled plugins
for plugin in $ERN_PLUGINS ; do
  [ -d ./_plugin/$plugin/r-branch/ ] && for filename in ./_plugin/$plugin/r-branch/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done
  [ -d ./_plugin/$plugin/r-all/ ] && for filename in ./_plugin/$plugin/r-all/* ; do
    MSYS2_ARG_CONV_EXCL="*" m4 -D__wid=$wid -D__workdir=$workdir -D__srcdir=$src -D__blddir=$bld -D__port=$port -D__bldtype=$bldtype -D__dll=$dll -D__branch=$branch -D__datadir=$workdir/dt $filename > $workdir/$(basename $filename)
    chmod +x $workdir/$(basename $filename)
  done
done

:

