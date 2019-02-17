#!/bin/bash
#
# Description:
# This script calls 'do_reposync.sh' to update the local mirror. After that the script 'update_multiple_stages.sh' is called to update all configured stage repositories.
#
# When all local repos were updated the Red Hat Errata Information are downloaded from the web and added to the local repos. This way you could provide Red Hat Errata Information to systems which are not connected to the internet or using repos from local mirror only.
#
# Version: 1.0.0
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
##############################################################################

# Variables ##################################################################
SCRIPTNAME=`basename ${0}`
PROGDIR=$(dirname $(readlink -f ${0}))
. $PROGDIR/CONFIG

# Functions #################################################################
deploy_updateinfo()
{
  /usr/bin/yum clean all
  /usr/bin/yum list-sec
  for REPO in "${LOCALREPOS[@]}"
    do
       /usr/bin/rm $REPODIR/$REPO/repodata/*updateinfo*
       /usr/bin/cp $CACHEDIR/*-updateinfo.xml.gz $REPODIR/$REPO/repodata/$TARGETGZFILENAME
       /usr/bin/gzip -d $REPODIR/$REPO/repodata/$TARGETGZFILENAME
       /usr/bin/modifyrepo $REPODIR/$REPO/repodata/$TARGETFILENAME $REPODIR/$REPO/repodata/
  done
}

# Main ##############################################################
echo \# `date +%Y-%m-%dT%H:%M` - Update Local Mirror \# > $LOG
bash $PROGDIR/do_reposync.sh >> $LOG

echo "\n" >> $LOG
echo \# `date +%Y-%m-%dT%H:%M` - Update rhel-STAGE-repositories \# >> $LOG
bash $PROGDIR/update_multiple_stages.sh >> $LOG

echo \# `date +%Y-%m-%dT%H:%M` - Implement Errata-Information \# >> $LOG
deploy_updateinfo >> $LOG
echo \# `date +%Y-%m-%dT%H:%M` - End of processing \# >> $LOG
# End ###############################################################
