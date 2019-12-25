#!/bin/bash
# Wrapper-Script to update the rhel-e-stage
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
$PROGDIR/rsync_repo.sh -Q rhel-8-for-x86_64-baseos-rpms -Z rhel-e-stage-baseos
$PROGDIR/rsync_repo.sh -Q rhel-8-for-x86_64-appstream-rpms -Z rhel-e-stage-appstream
exit
