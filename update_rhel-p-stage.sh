#!/bin/bash
# Wrapper-Script to update the rhel-p-stage
# License: MIT copyright (c) 2019 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
$PROGDIR/rsync_repo.sh -Q rhel-q-stage-baseos -Z rhel-p-stage-baseos
$PROGDIR/rsync_repo.sh -Q rhel-q-stage-appstream -Z rhel-p-stage-appstream
exit
