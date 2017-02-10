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

LOG="/var/log/do_reposync.log"
REPOID=(rhel-7-server-rpms rhel-server-rhscl-7-rpms rhel-7-server-optional-rpms rhel-7-server-extras-rpms rhel-7-server-thirdparty-oracle-java-rpms rhel-7-server-supplementary-rpms)
DOWNLOADPATH="/rpm-repo"

echo \# `date +%Y-%m-%dT%H:%M` - START REPOSYNC \# > $LOG

for REPO in "${REPOID[@]}"
  do
    reposync --gpgcheck -l --repoid=$REPO --download_path=$DOWNLOADPATH --downloadcomps --download-metadata -n >> $LOG
    cd $DOWNLOADPATH/$REPO
    if [[ -e comps.xml ]]; then
      createrepo -v $DOWNLOADPATH/$REPO -g comps.xml >> $LOG
    else
      createrepo -v $DOWNLOADPATH/$REPO >> $LOG
    fi
done

echo \# `date +%Y-%m-%dT%H:%M` - END REPOSYNC \# >> $LOG
exit 0
