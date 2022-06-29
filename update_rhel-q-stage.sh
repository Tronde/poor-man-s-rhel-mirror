#!/bin/bash
# Wrapper-Script to update the rhel-q-stage
# License: MIT copyright (c) 2019 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
$PROGDIR/rsync_repo.sh -Q rhel-i-stage-baseos -Z rhel-q-stage-baseos
$PROGDIR/rsync_repo.sh -Q rhel-i-stage-appstream -Z rhel-q-stage-appstream
exit
