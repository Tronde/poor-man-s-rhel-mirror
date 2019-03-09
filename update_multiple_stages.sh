#!/bin/bash
# Descripiton: 
# Wrapper-Script to update multiple stages with the CRON-Daemon
# License: MIT copyright (c) 2016 Joerg Kastning <joerg.kastning(aet)uni-bielefeld(dot)de>
PROGDIR=$(dirname $(readlink -f ${0}))
bash $PROGDIR/update_rhel-e-stage.sh && $PROGDIR/update_rhel-i-stage.sh && $PROGDIR/update_rhel-q-stage.sh && $PROGDIR/update_rhel-p-stage.sh
exit 0
