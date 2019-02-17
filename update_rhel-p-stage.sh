#!/bin/bash
# Wrapper-Script to update the rhel-p-stage
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
$PROGDIR/rsync_repo.sh -Q rhel-q-stage -Z rhel-p-stage
exit
