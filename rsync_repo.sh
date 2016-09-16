#!/bin/bash
# Sychronisation von zwei Paketquellen auf dem lokalen Spiegelserver
# Description:
# This script could be used to synchronize to package repositories
# on the local mirror server.
#
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>

# Variables ########################################################
LOG="/var/log/rsync_repo.log"
BASEDIR="/var/www/html/local-rhel-7-repo/" # Path where the local repos are stored.
PACKAGELIST_PATH=""

# Functions #######################################################
usage()
{
  cat << EOF
  usage: $0 OPTIONS
  This script could be used to synchronize to package repositories
  on the local mirror server.

  OPTIONS:
  -f Specifies a file containing a list of packages to be synchronized
  -h Shows this text
  -Q Specifies the source directory
  -Z Specifies the target directory
EOF
}

check()
{
  if [ $1 -gt 0 ]; then
    echo "Uuups, here went something wrong."
    echo "exit $1"
    exit 1
  fi
}

do_sync_repo()
{
  rsync -avx --link-dest=$BASEDIR$SOURCEDIR $BASEDIR$SOURCEDIR/ $BASEDIR$TARGETDIR
  cd $BASEDIR$TARGETDIR
}

do_sync_pkg()
{
  while read line
  do
     cp -al $line $BASEDIR$TARGETDIR/Packages
  done < $PACKAGELIST_PATH
  cd $BASEDIR$TARGETDIR/Packages
  createrepo -v --database $BASEDIR$TARGETDIR/Packages
}

# Main #######################################################
while getopts .h:Q:Z:f:. OPTION
do
  case $OPTION in
    h)
       usage
       exit;;
    Q)
       SOURCEDIR="${OPTARG}"
       ;;
    f)
       PACKAGELIST_PATH="${OPTARG}"
       ;;
    Z)
       TARGETDIR="${OPTARG}"
       ;;
    ?)
       usage
       exit;;
  esac
done

if [[ -z $SOURCEDIR && -z $PACKAGELIST_PATH ]]; then
  read -p "Please enter the source directory: " SOURCEDIR
fi

if [[ -z $TARGETDIR ]]; then
  read -p "Please enter the target directory: " TARGETDIR
fi

if [[ ! -z $PACKAGELIST_PATH ]]; then
  echo \# `date +%Y-%m-%dT%H:%M` - START RSYNC \# > $LOG
  do_sync_pkg >> $LOG
  check $? >> $LOG
  echo \# `date +%Y-%m-%dT%H:%M` - END RSYNC \# >> $LOG
else
  echo \# `date +%Y-%m-%dT%H:%M` - START RSYNC \# > $LOG
  do_sync_repo >> $LOG
  check $? >> $LOG
  echo \# `date +%Y-%m-%dT%H:%M` - END RSYNC \# >> $LOG
fi

exit 0
