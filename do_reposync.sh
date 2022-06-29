#!/bin/bash
#
# Description:
# This is a script to synchronize a RHEL-Repository to dir on a host in your
# LAN to build a local mirror server. The server where this script should be
# used on needs to have a valid subscription for the repository which should
# be synchronized.
#
# Author: Joerg Kastning <joerg.kastning@uni-bielefel.de>
# License: MIT copyright (c) 2019 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>

# Variables
SCRIPTNAME=`basename ${0}`
PROGDIR=$(dirname $(readlink -f ${0}))
. $PROGDIR/CONFIG

# Main
echo \# `date +%Y-%m-%dT%H:%M` - START REPOSYNC \# > $LOG

for REPO in "${REPOID[@]}"
  do
<<<<<<< HEAD
    reposync --gpgcheck -l --repoid=$REPO --download_path=$BASEDIR --download-metadata -n >> $LOG
    cd $BASEDIR/$REPO
    if [[ -e comps.xml ]]; then
      createrepo -v $BASEDIR/$REPO -g comps.xml >> $LOG
    else
      createrepo -v $BASEDIR/$REPO >> $LOG
    fi
=======
    reposync --repoid=$REPO --download-path=$BASEDIR --downloadcomps --download-metadata -n >> $LOG
>>>>>>> 471d2bda4bcff8ded93c5b49c2621e0a2b86090a
done

echo \# `date +%Y-%m-%dT%H:%M` - END REPOSYNC \# >> $LOG
exit 0
