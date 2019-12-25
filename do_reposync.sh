#!/bin/bash
#
# Description:
# This is a script to synchronize a RHEL-Repository to dir on a host in your
# LAN to build a local mirror server. The server where this script should be
# used on needs to have a valid subscription for the repository which should
# be synchronized.
#
# Author: Joerg Kastning <joerg.kastning@uni-bielefel.de>
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>

# Variables
SCRIPTNAME=`basename ${0}`
PROGDIR=$(dirname $(readlink -f ${0}))
. $PROGDIR/CONFIG

# Main
echo \# `date +%Y-%m-%dT%H:%M` - START REPOSYNC \# > $LOG

for REPO in "${REPOID[@]}"
  do
    reposync --repoid=$REPO --download-path=$BASEDIR --downloadcomps --download-metadata -n >> $LOG
done

echo \# `date +%Y-%m-%dT%H:%M` - END REPOSYNC \# >> $LOG
exit 0
