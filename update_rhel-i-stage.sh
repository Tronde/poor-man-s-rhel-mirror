#!/bin/bash
# Wrapper-Script to update the rhel-i-stage
# License: MIT copyright (c) 2019 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
$PROGDIR/rsync_repo.sh -Q rhel-e-stage-baseos -Z rhel-i-stage-baseos
$PROGDIR/rsync_repo.sh -Q rhel-e-stage-appstream -Z rhel-i-stage-appstream
exit
