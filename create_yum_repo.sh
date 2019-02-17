#!/bin/bash
#
# Description:
# This script creates a YUM-Repository on your host, which could be used to
# distribute RPM-Packages to other hosts.
#
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>

# Variablen ###################################################################
SCRIPTNAME=`basename ${0}`
PROGDIR=$(dirname $(readlink -f ${0}))
. $PROGDIR/CONFIG
REPONAME="" # Name for the new repository

# Funktionen ##################################################################
usage()
{
  cat << EOF
  usage: $0 OPTIONS
  This script creates a new YUM-Repository on the local host.

  REPONAME is passed to the script by parameter.

  OPTIONS:
  -h Shows this text.
  -r <repo-name> Name of the new repository. Only A..Z, a..z, 0..9 and '-' are
     allowed for the name. The name must not contain any spaces.
EOF
}

check()
{
  if [ $1 -gt 0 ]; then
    echo "Uuups, here went something wrong"
    echo "exit $1"
    exit 1
  fi
}

create_repo()
{
mkdir $BASEDIR$REPONAME
createrepo --database $BASEDIR$REPONAME 
REPOID=`echo $REPONAME | tr "[a-z]" "[A-Z]"`

#cat >> $BASEDIR/$REPONAME.repo << EOF
#[$REPOID]
#name= RHEL \$releasever - \$basearch (local)
#baseurl=$HOST/`basename $BASEDIR`/$REPONAME/
#enabled=1
#gpgcheck=1
#gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
#EOF
}

# Main #######################################################
while getopts .h:r:. OPTION
do
  case $OPTION in
    h)
       usage
       exit;;
    r)
       REPONAME="${OPTARG}"
       ;;
    ?)
       usage
       exit;;
  esac
done

if [[ -z $REPONAME ]]; then
  read -p "Please enter the repository name: " REPONAME
fi

echo \# `date +%Y-%m-%d` - START SYNC \# > $LOG
create_repo >> $LOG
check $? >> $LOG
echo \# `date +%Y-%m-%d` - END SYNC \# >> $LOG
exit 0
